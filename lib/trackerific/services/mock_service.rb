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
        :delivered => true,
        :out_for_delivery => true
      })

      details.events << Event.new(format_time(Time.now - (60*60*24*5)), "Picked up", "Los Angeles CA")
      details.events << Event.new(format_time(Time.now - (60*60*24*2)), "Packaged scanned", "Santa Barbara, CA")
      details.events << Event.new(format_time, "Package delivered", "Santa Maria, CA")

      details
    end

    private
    def format_time(time = Time.now)
      time.strftime("%Y-%m-%d %H:%i %P")
    end
  end
end
