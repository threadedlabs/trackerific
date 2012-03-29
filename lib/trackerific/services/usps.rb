require 'httparty'
require 'builder'

module Trackerific
  class USPS < Service
    REGEXES = [
      /^E\D{1}\d{9}\D{2}$|^9\d{15,21}$/,
      /^\d{4}\s\d{4}\s\d{4}\s\d{4}\s\d{4}\s\d{2}$/
    ]

    include HTTParty
    format :xml

    def self.tracks?(number)
      !REGEXES.select { |r| number.to_s.match(r) }.empty?
    end

    private
    def send_request
      response = self.class.get config.url, :query => {
        :API => 'TrackV2', :XML => build_tracking_xml_request }.to_query
    end

    def create_details(response)
      tracking_info = response['TrackResponse']['TrackInfo']
      events = []

      tracking_info['TrackDetail'].reverse.each do |d|
        events << Event.new(date_of_event(d), description_of_event(d).capitalize, location_of_event(d))
      end unless tracking_info['TrackDetail'].nil?

      Package.new(
        :package_id => tracking_info['ID'],
        :summary    => tracking_info['TrackSummary'],
        :events     => events
      )
    end

    def check_for_errors!(response)
      return response.error unless response.code == 200

      raise ServiceError, response['Error']['Description'] unless response['Error'].nil?
      raise ServiceError, "Tracking information not found in response from server." if response['TrackResponse'].nil?
    end

    private
    def date_of_event(event)
      # get the date out of
      # Mon DD HH:MM am/pm THE DESCRIPTION CITY STATE ZIP.
      d = event.split " "
      d[0..3].join " "
    end

    def description_of_event(event)
      # get the description out of
      # Mon DD HH:MM am/pm THE DESCRIPTION CITY STATE ZIP.
      d = event.split(" ")
      d[4..d.length-4].join(" ").capitalize
    end
    def location_of_event(event)
      # remove periods, and split by spaces
      d = event.gsub(".", "").split(" ")
      l = d[d.length-3, d.length] # => ['city', 'state', 'zip']
      # this is the location from the USPS tracking XML. it is not guaranteed
      # to be completely accurate, since there's no way to know if it will
      # always be the last 3 words.
      city  = l[0]
      state = l[1]
      zip   = l[2]

      "#{city.titleize}, #{state} #{zip}".strip
    end

    # Builds an XML tracking request
    # @return [String] the xml request
    # @api private
    def build_tracking_xml_request
      xml = ""

      builder = ::Builder::XmlMarkup.new :target => xml 
      builder.TrackRequest :USERID => config.user_id do |t|
        t.TrackID :ID => package_id
      end

      xml
    end
  end
end
