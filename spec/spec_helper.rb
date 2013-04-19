# coding: utf-8

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'

require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'mongoid'
require 'database_cleaner'
require 'mongoid-rspec'
require 'faker'
require 'mongoid_snappy'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Mongoid.configure do |config|
  ENV["MONGOID_ENV"] = "test"
  Mongoid.load!("spec/support/mongoid.yml")
end

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.strategy = :truncation
  end
  config.after :each do
    DatabaseCleaner.clean
  end
  config.include Mongoid::Matchers
  config.mock_with :rspec
end