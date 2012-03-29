module Trackerific
  class Package
    def initialize(details = {})
      @package_id = details[:package_id]
      @events = details[:events]
      @delivered = details[:delivered] || false
      @out_for_delivery = details[:out_for_delivery] || false
    end

    def package_id
      @package_id
    end

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
      events.last.description
    end
  end
end
