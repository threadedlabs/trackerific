module Trackerific
  class Fedex < Trackerific::Service
    REGEXES = [ 
      /^[0-9]{15}$/, 
      /^[0-9]{12}/
    ]

    include ::HTTParty
    format :xml

    def self.tracks?(number)
      !REGEXES.select { |r| number =~ r }.empty?
    end

    private
    def send_request
      self.class.post config.url, :body => build_xml_request
    end

    def build_xml_request
      xml = ""

      xmlns_api = "http://www.fedex.com/fsmapi"
      xmlns_xsi = "http://www.w3.org/2001/XMLSchema-instance"
      xsi_noNSL = "FDXTrack2Request.xsd"

      # create a new Builder to generate the XML
      builder = ::Builder::XmlMarkup.new(:target => xml)
      builder.instruct! :xml, :version => "1.0", :encoding => "UTF-8"

      builder.FDXTrack2Request "xmlns:api" => xmlns_api, "xmlns:xsi"=> xmlns_xsi, "xsi:noNamespaceSchemaLocation" => xsi_noNSL do |r|
        r.RequestHeader do |rh|
          rh.AccountNumber config.account
          rh.MeterNumber config.meter
        end
        r.PackageIdentifier do |pi|
          pi.Value package_id
        end
        r.DetailScans true
      end
      xml
    end

    def check_for_errors!(response)
      response.error! unless response.code == 200

      reply = response["FDXTrack2Reply"]
      raise Trackerific::ServiceError, reply["Error"]["Message"] unless reply["Error"].nil?
    end

    def create_details(response)
      details = response['FDXTrack2Reply']["Package"]

      events = []

      details["Event"].each do |e|
        date = Time.parse("#{e["Date"]} #{e["Time"]}")
        desc = e["Description"]
        addr = e["Address"]

        if addr
          location = "#{addr['City']}, #{addr["StateOrProvinceCode"]} #{addr["PostalCode"]} #{addr['CountryCode']}"
        else
          location = 'Unknown'
        end

        events << Trackerific::Event.new(
          :time         => date,
          :description  => desc,
          :location     => location
        )
      end
      # Return a Trackerific::Details containing all the events
      Trackerific::Details.new(
        :package_id => details["TrackingNumber"],
        :summary    => details["StatusDescription"],
        :events     => events
      )
    end
  end
end
