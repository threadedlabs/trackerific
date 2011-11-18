module Trackerific
  class UPS < Trackerific::Service
    REGEXES = [
       /^.Z/, 
       /^[HK].{10}$/ 
    ]

    include ::HTTParty
    format :xml

    def self.tracks?(number)
      !REGEXES.select { |r| number =~ r }.empty?
    end

    private
    def send_request
      self.class.post "#{config.url}/Track", :body => build_xml_request
    end

    def build_xml_request
      xml = ""
      builder = ::Builder::XmlMarkup.new(:target => xml)

      builder.AccessRequest do |ar|
        ar.AccessLicenseNumber config.key
        ar.UserId config.user_id
        ar.Password config.password
      end

      builder.TrackRequest do |tr|
        tr.Request do |r|
          r.RequestAction 'Track'
          r.RequestOption 'activity'
        end
        tr.TrackingNumber package_id
      end

      xml
    end

    def check_for_errors!(response)
      response.error! unless response.code == 200

      code = response['TrackResponse']['Response']['ResponseStatusCode']

      if code == "0"
        raise Trackerific::ServiceError, response['TrackResponse']['Response']['Error']['ErrorDescription']
      elsif code != "1"
        raise Trackerific::ServiceError, "Invalid response code returned from server."
      end
    end

    def create_details(response)
      package = response['TrackResponse']['Shipment']['Package']
      # get the activity from the UPS response
      activity = package['Activity']

      # if there's only one activity in the list, we need to put it in an array
      activity = [activity] if activity.is_a? Hash

      # UPS does not provide a summary, so we'll just use the last tracking status
      summary = activity.first['Status']['StatusType']['Description'].titleize

      events = []

      activity.each do |a|
        # the time format from UPS is HHMMSS, which cannot be directly converted
        # to a Ruby time.
        hours   = a['Time'][0..1]
        minutes = a['Time'][2..3]
        seconds = a['Time'][4..5]
        date    = Date.parse(a['Date'])
        date    = DateTime.parse("#{date} #{hours}:#{minutes}:#{seconds}")
        desc    = a['Status']['StatusType']['Description'].titleize
        loc     = a['ActivityLocation']['Address'].map {|k,v| v}.join(" ")
        events << Trackerific::Event.new(
          :date         => date,
          :description  => desc,
          :location     => loc
        )
      end

      Trackerific::Details.new(
        :package_id => package_id,
        :summary    => summary,
        :events     => events
      )
    end
  end
end
