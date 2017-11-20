require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.filter_sensitive_data('<BITSTAMP_KEY>') { ENV['BITSTAMP_KEY'] }
  c.filter_sensitive_data('<BITSTAMP_SECRET>') { ENV['BITSTAMP_SECRET'] }
end
