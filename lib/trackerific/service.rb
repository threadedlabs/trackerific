require 'httparty'
require 'builder'

module Trackerific
  # Base class for Trackerific services
  class Service

    # Returns true if the service can track the specific tracking number
    # @return Boolean
    def self.tracks?(package_id)

    end

    # Gets the tracking information for the package from the server
    # @param [String] package_id the package identifier
    # @return [Trackerific::Details] the tracking details
    # @example Override this method in your custom tracking service to implement tracking
    #   module Trackerific
    #     class MyTrackingService < Trackerific::Service
    #       def track_package
    #         # your tracking code here
    #         Trackerific::Details.new(
    #           "summary of tracking events",
    #           [Trackerific::Event.new(Time.now, "summary", "location")]
    #         )
    #       end
    #     end
    #   end
    # @api semipublic
    def self.track(package_id)
      new(package_id).track
    end

    def self.config
      name =to_s.split('::').last.underscore
      Trackerific.configuration.send(name)
    end

    def initialize(package_id)
      @package_id = package_id
      raise UnknownPackageId unless self.class.tracks?(package_id)
    end

    def track
      response = send_request
      check_for_errors! response
      create_details response
    end

    private
    def package_id
      @package_id
    end

    def config
      self.class.config
    end
  end
end
