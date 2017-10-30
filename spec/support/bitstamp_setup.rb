RSpec.configure do |config|
  config.before(:each) do
    # The famous singleton problem
    Bitstamp.setup do |config|
      config.key = nil
      config.secret = nil
      config.client_id = nil
      config.api_url = nil
    end
  end
end

def setup_bitstamp
  Bitstamp.setup do |config|
    if ENV['BITSTAMP_KEY'].nil? || ENV['BITSTAMP_SECRET'].nil? || ENV['BITSTAMP_API_URL'].nil?
      raise "You must set environment variable BITSTAMP_KEY, BITSTAMP_SECRET and BITSTAMP_API_URL to run specs."
    end

    config.key = ENV['BITSTAMP_KEY']
    config.secret = ENV['BITSTAMP_SECRET']
    config.client_id = ENV['BITSTAMP_CLIENT_ID']
    config.api_url = ENV['BITSTAMP_API_URL']
  end
end
