require 'rest_client'
require 'openssl'
require 'json'

module Bitstamp
  class Client
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def call(method:, path:, payload: {}, auth: false)
      url = "#{config.api_url.chomp('/')}/#{path}"

      payload = payload.merge(auth_params) if auth

      logger.info("Bitstamp: sending #{method} '#{url}'")

      response = RestClient::Request.execute(
        method: method,
        url: url,
        payload: payload,
        proxy: config.proxy,
        ssl_version: 'SSLv23'
      )

      logger.info("Bitstamp: finished #{method} '#{url}' with #{response.code}")

      result = JSON.parse(response)

      if result.is_a?(Hash) && result['status'] == 'error'
        message = "Bitstamp: failed #{method} '#{url}' with #{response.code} #{result}"
        logger.error(message)
        raise Error, message
      else
        result
      end

      JSON.parse(response)
    rescue RestClient::ExceptionWithResponse => e
      logger.error("Bitstamp: failed #{method} '#{url}' with #{e.http_code} #{e.response}")
      raise
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
      OpenSSL::HMAC.hexdigest('SHA256', config.secret, nonce + config.customer_id.to_s + config.key).upcase
    end

    def logger
      config.logger
    end
  end
end
