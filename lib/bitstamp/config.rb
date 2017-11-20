module Bitstamp
  class Config
    attr_accessor :api_url
    attr_accessor :proxy
    attr_accessor :key
    attr_accessor :secret
    attr_accessor :customer_id
    attr_writer :logger

    def logger
      @logger ||= Logger.new(nil)
    end
  end
end
