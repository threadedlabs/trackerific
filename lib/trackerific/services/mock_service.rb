module Trackerific
  # Provides a mock service for using in test and development
  class MockService < Service

    INVALID_TRACKING_NUMBER = 'XXXxxxxxxx'
    VALID_TRACKING_NUMBER = 'XXXXXXXXXX'

    def self.tracks?(tracking_number)
      tracking_number == VALID_TRACKING_NUMBER || tracking_number == INVALID_TRACKING_NUMBER
    end

    def track
      if package_id == INVALID_TRACKING_NUMBER
        raise UnknownPackageId, "#{package_id} is invalid!"
      end

      details = Trackerific::Package.new({
        :package_id => package_id,
        :summary    => "At door step",
      })

      details.events << Event.new({
        :time         => Time.now,
        :description  => "Package delivered.",
        :location     => "SANTA MARIA, CA"
      })

      details.events << Event.new({
        :time         => Time.now - (60*60*24*2),
        :description  => "Package scanned.",
        :location     => "SANTA BARBARA, CA"
      })

      details.events << Event.new({
        :time         => Time.now - (60*60*24*5),
        :description  => "Package picked up for delivery.",
        :location     => "LOS ANGELES, CA"
      })

      details
    end
  end
end
