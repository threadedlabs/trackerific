module Trackerific
  class Package
    # Provides a new instance of Details
    # @param [Hash] details The details for this package
    # @api private
    def initialize(details = {})
      @package_id = details[:package_id]
      @events = details[:events]
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
