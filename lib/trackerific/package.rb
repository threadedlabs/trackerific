module Trackerific
  class Package
    # Provides a new instance of Details
    # @param [Hash] details The details for this package
    # @api private
    def initialize(details = {})
      @package_id = details[:package_id]
      @events = details[:events]
      @weight = details[:weight] || nil
      @via = details[:via] || nil
      @delivered = details[:delivered] || false
      @out_for_delivery = details[:out_for_delivery] || false
    end

    # The package identifier
    # @example Get the id of a tracked package
    #   details.package_id # => the package identifier
    # @return [String] the package identifier
    # @api public
    def package_id
      @package_id
    end

    # The events for this package
    # @example Print all the events for a tracked package
    #   puts details.events
    # @example Get the date the package was shipped
    #   details.events.last.date # => a DateTime value
    # @example A bulleted HTML list of the events (most current on top) in haml
    #   %ul
    #     - details.events.each do |event|
    #       %li= event
    # @return [Array, Trackerific::Event] the tracking events
    # @api public
    def events
      @events ||= []
    end

    # The weight of the package (may not be supported by all services)
    # @example Get the weight of a package
    #   details.weight[:weight] # => the weight
    #   details.weight[:units]  # => the units of measurement for the weight (i.e. "LBS")
    # @return [Hash] Example: { units: 'LBS', weight: 19.1 }
    # @api public
    def weight
      @weight
    end

    # Example: UPS 2ND DAY AIR. May not be supported by all services
    # @example Get how the package was shipped
    #   ups = Trackerific::UPS.new :user_id => "userid"
    #   details = ups.track_package "1Z12345E0291980793"
    #   details.via # => "UPS 2ND DAY AIR"
    # @return [String] The service used to ship the package
    # @api public
    def via
      @via
    end

    def delivered
      @delivered
    end

    def out_for_delivery
      @out_for_delivery
    end

    def description
      events.first.description
    end
  end
end
