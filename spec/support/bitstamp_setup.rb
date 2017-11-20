RSpec.configure do |config|
  config.before(:each) do
    Bitstamp.configure do |config|
      if ENV['BITSTAMP_KEY'].nil? || ENV['BITSTAMP_SECRET'].nil? || ENV['BITSTAMP_API_URL'].nil?
        raise "You must set environment variable BITSTAMP_KEY, BITSTAMP_SECRET and BITSTAMP_API_URL to run specs."
      end

      config.api_url = ENV['BITSTAMP_API_URL']
      config.key = ENV['BITSTAMP_KEY']
      config.secret = ENV['BITSTAMP_SECRET']
      config.customer_id = ENV['BITSTAMP_CUSTOMER_ID']
    end
  end
end
