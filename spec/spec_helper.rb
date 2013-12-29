require 'rspec'
require 'capybara'
require 'capybara/dsl'

ENV['RACK_ENV'] = 'test'

PROJECT_ROOT_PATH = File.dirname(File.dirname(__FILE__))
FIXTURES_ROOT = File.join(PROJECT_ROOT_PATH, 'fixtures')

RSpec.configure do |config|
  config.include Capybara::DSL
end
