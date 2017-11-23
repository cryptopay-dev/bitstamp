require 'openssl'
require 'json'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'
require 'active_support/gzip'

module Bitstamp
  class Client
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def call(method:, path:, payload: {}, auth: false)
      url = URI.join("#{config.api_url.chomp('/')}/#{path}")

      payload = payload.merge(auth_params) if auth

      logger.info("Bitstamp: sending #{method} '#{url}'")

      http = build_http(url)
      request = build_request(method, url, payload)
      response = http.request(request)

      logger.info("Bitstamp: finished #{method} '#{url}' with #{response.code}")

      check_response_error(response)
      parse_response(method, url, response)
    end

    private

    def build_http(url)
      if config.proxy
        proxy_uri = URI.parse(config.proxy)
        http = Net::HTTP.new(url.host, url.port, proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
      else
        http = Net::HTTP.new(url.host, url.port)
      end

      http.use_ssl = true if url.scheme == 'https'

      http
    end

    def build_request(method, url, payload)
      klass = "Net::HTTP::#{method.to_s.camelize}".safe_constantize
      raise "Unsupported request method #{method}" unless klass

      request = klass.new(url.request_uri)
      request.body = URI.encode_www_form(payload) if payload.present? && method != :get

      request.add_field('Content-Type', 'application/x-www-form-urlencoded')
      request.add_field('Accept', 'application/json')

      request
    end

    def check_response_error(response)
      response.error! if response.is_a?(Net::HTTPServerError)
    end

    def parse_response(method, url, response)
      data = response.body
      data = ActiveSupport::Gzip.decompress(data) if response['Content-Encoding'] == 'gzip'
      data = JSON.parse(data)

      if data.is_a?(Hash) && data['status'] == 'error'
        message = "Bitstamp: failed #{method} '#{url}' with #{response.code} #{data}"
        logger.error(message)
        raise Error, message
      else
        data
      end
    rescue JSON::ParserError
      message = "Bitstamp: failed #{method} '#{url}' with #{response.code} malformed response: #{data}"
      logger.error(message)
      raise Error, message
    end

    private

    def auth_params
      nonce = (Time.now.to_f * 1000000).to_i.to_s

      {
        key: config.key,
        nonce: nonce,
        signature: generate_signature(nonce)
      }
    end

    def generate_signature(nonce)
      OpenSSL::HMAC.hexdigest('SHA256', config.secret.to_s, nonce + config.customer_id.to_s + config.key.to_s).upcase
    end

    def logger
      config.logger
    end
  end
end
