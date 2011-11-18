module Trackerific
  # Provides details for a tracking event
  class Event
    # Provides a new instance of Event
    # @param [Hash] details The details of the event
    # @api private
    def initialize(details = {})
      @time         = details[:time]
      @description  = details[:description]
      @location     = details[:location]
    end

    # The date and time of the event
    # @example Get the date of an event
    #   date = details.events.first.time
    # @return [Time]
    # @api public
    def time
      @time
    end

    # The event's description
    # @example Get the description of an event
    #   description = details.events.first.description
    # @return [String]
    # @api public
    def description
      @description
    end

    # Where the event took place (usually in City State Zip format)
    # @example Get the location of an event
    #   location = details.events.first.location
    # @return [String]
    # @api public
    def location
      @location
    end

    # Converts the event into a string
    # @example Get a human-readable string from an event
    #   event = details.event.to_s
    # @example A bulleted list of events in haml
    #   %ul
    #     - details.events.each do |event|
    #     %li= event
    # @return [String] converts the event into a string
    # @api public
    def to_s
      dte = self.time.strftime('%b %d %I:%M %P')
      des = self.description
      loc = self.location
      "#{dte} #{des} #{loc}"
    end
  end
end
