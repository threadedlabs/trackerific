# Code coverage
require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler/setup'
require 'trackerific'

# load all the support files
Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.mock_with :rspec
end

require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    Trackerific.configure do |trackerific|
      trackerific.fedex.meter = 'meter'
      trackerific.fedex.account = 'account-id'
    end
  end

  config.after(:each) do
    Trackerific.configuration = nil
  end
end
