module Trackerific
  class Ontrac < Service
    def self.tracks?(number)
      !number.match(/C\d{14}/).nil?
    end

    def track
      html = Fetchers::Ontrac.fetch package_id
      info = Parsers::Ontrac.new html

      attributes = {}

      attributes[:delivered] = info.delivery_status.eql?('DELIVERED')
      attributes[:out_for_delivery] = info.delivery_status.eql?('OUT FOR DELIVERY')
      attributes[:package_id] = package_id

      attributes[:events] = info.history.map do |event|
        Event.new :time => event.timestamp, 
          :description => event.description, 
          :location => event.location
      end

      Package.new attributes
    end
  end
end
