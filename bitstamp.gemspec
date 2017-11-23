require File.expand_path('../lib/bitstamp/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'bitstamp'
  s.version = Bitstamp::VERSION

  s.authors = ['Jeffrey Wilcke']
  s.date = '2014-03-09'
  s.description = 'Ruby API for use with bitstamp.'
  s.email = 'stygeo@gmail.com'
  s.homepage = 'http://github.com/kojnapp/bitstamp'
  s.license = 'MIT'
  s.summary = 'Bitstamp Ruby API'

  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.require_paths = ['lib']

  s.add_dependency 'virtus', '~> 1.0'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'bundler', '~> 1.13'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'dotenv'
end
