module Trackerific
  class Service
    def self.tracks?(package_id)

    end

    def self.track(package_id)
      new(package_id).track
    end

    def self.config
      name =to_s.split('::').last.underscore
      Trackerific.configuration.send(name)
    end

    def initialize(package_id)
      @package_id = package_id
      raise UnknownPackageId unless self.class.tracks?(package_id)
    end

    def track
      response = send_request
      check_for_errors! response
      create_details response
    end

    private
    def package_id
      @package_id
    end

    def config
      self.class.config
    end
  end
end
