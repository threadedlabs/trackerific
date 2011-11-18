require 'spec_helper'

class TestService < Trackerific::Service
  def self.tracks?(number)
    number == 'test-tracking-number'
  end
end

describe Trackerific::Service do
  describe "Service.config" do
    it "should use the class name to look up the configuration" do
      Trackerific.configuration.should_receive(:test_service)

      TestService.config
    end
  end

  describe "Service.track" do
    subject { TestService }

    it "should raise an error if the service can't handle the number" do
      lambda { 
        subject.track 'lolwut'
      }.should raise_error(Trackerific::UnknownPackageId)
    end

    it "should instantiate a new instance then track it" do
      service = double('service')

      subject.stub(:new).with('test-tracking-number').and_return(service)
      service.should_receive(:track)

      subject.track 'test-tracking-number'
    end
  end
end
