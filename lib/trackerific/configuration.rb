module Trackerific
  class << self
    def configuration
      @configuration ||= Trackerific::Configuration.new
    end

    def configuration=(value)
      @configuration=(value)
    end

    def configure
      yield configuration
      configuration
    end
  end

  private
  class Configuration
    def fedex
      @fedex_configuration ||= FedexConfiguration.new
      yield @fedex_configuration if block_given?
      @fedex_configuration
    end

    def ups
      @ups_configuration ||= UpsConfiguration.new
      yield @ups_configuration if block_given?
      @ups_configuration
    end

    def usps
      @usps_configuration ||= UspsConfiguration.new
      yield @usps_configuration if block_given?
      @usps_configuration
    end
  end

  class FedexConfiguration
    attr_accessor :meter, :account, :url

    def url
      @url || 'https://gateway.fedex.com/GatewayDC'
    end
  end

  class UpsConfiguration
    attr_accessor :key, :user_id, :password, :url

    def url
      @url || 'https://wwwcie.ups.com/ups.app/xml'
    end
  end

  class UspsConfiguration
    attr_accessor :user_id, :url

    def url
      @url || 'http://testing.shippingapis.com/ShippingAPITest.dll'
    end
  end
end
