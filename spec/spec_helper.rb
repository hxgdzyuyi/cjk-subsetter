require 'rspec'
require 'capybara'
require 'capybara/dsl'

ENV['RACK_ENV'] = 'test'

Capybara.app = Rack::Builder.parse_file(
  File.join(File.dirname(__FILE__), '../example/config.ru')).first

RSpec.configure do |config|
  config.include Capybara::DSL
end
