require 'trackerific/configuration'
require 'trackerific/service'
require 'trackerific/errors'
require 'trackerific/package'
require 'trackerific/event'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/to_query'

# require all the Trackerific services
services_path = File.join(File.dirname(__FILE__), "trackerific", "services", "**", "*.rb")
Dir[File.expand_path(services_path)].each { |file| require file }

# Trackerific provides package tracking to Rails apps.
module Trackerific

  extend self

  # Checks a string for a valid package tracking service
  # @param [String] package_id the package identifier
  # @return [Trackerific::Base] the Trackerific class that can track the given
  #   package id, or nil if none found.
  # @example Find out which service provider will track a valid FedEx number
  #   Trackerific.service "183689015000001" # => Trackerific::FedEx
  # @api public
  def service(package_id)
    match = [UPS, Fedex, USPS, MockService].select { |s| s.tracks? package_id }.first

    if match
       match
    else 
      nil
    end
  end

  # Tracks a package by determining its service from the package id
  # @param [String] package_id the package identifier
  # @return [Trackerific::Details] the tracking results
  # @raise [Trackerific::Error] raised when the server returns an error (invalid credentials, tracking package, etc.)
  # @example Track a package
  #   # make sure to configure Trackerific before hand with the different services credentials
  #   Trackerific.config do |config|
  #     config.fedex.meter ='123456789'
  #     config.fedex.account = '123456789'
  #   end
  #
  #   details = Trackerific.track "183689015000001"
  # @api public
  def track(package_id)
    tracker = service package_id

    raise Trackerific::UnknownPackageId, "Cannot find a service to track package id #{package_id}" unless tracker

    tracker.track package_id
  end
end
