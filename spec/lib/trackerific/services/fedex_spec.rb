require 'spec_helper'

describe Trackerific::Fedex do
  before(:each) do
    config.meter = 'meter'
    config.account = 'account-id'
  end

  let(:package_id) { "183689015000001" }
  let(:config) { subject.config }

  let(:request) do
    %Q{
      <?xml version="1.0" encoding="UTF-8"?>
      <FDXTrack2Request xmlns:api="http://www.fedex.com/fsmapi" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="FDXTrack2Request.xsd">
      <RequestHeader>
        <AccountNumber>#{config.account}</AccountNumber>
        <MeterNumber>#{config.meter}</MeterNumber>
      </RequestHeader>
      <PackageIdentifier>
        <Value>#{package_id}</Value>
      </PackageIdentifier>
      <DetailScans>true</DetailScans>
    </FDXTrack2Request>
    }.split("\n").map(&:strip).join('')
  end

  subject { Trackerific::Fedex }

  it "should be able to track fedex ground packages" do
    subject.tracks?("491428716545").should be_true
  end

  it "should be able to track fedex express packages" do
    subject.tracks?("183689015000001").should be_true
  end

  describe "When the the package has been delivered" do
    before(:each) do
      stub_request(:post, config.url).
        with(:body => request).
        to_return(:body => load_fixture(:fedex_delivery_response))
    end

    it "should assign the package id" do
      results = Trackerific::Fedex.new(package_id).track
      results.package_id.should eql(package_id)
    end

    it "should set the description" do
      package = Trackerific::Fedex.new(package_id).track
      package.description.should eql('Delivered: Left at garage. Signature Service not requested.')
    end

    it "should parse all the events" do
      results = Trackerific::Fedex.new(package_id).track
      results.events.size.should eql(4)
    end

    it "should say the package has been delivered" do
      package = Trackerific::Fedex.new(package_id).track
      package.delivered.should be_true
    end
  end

  describe "Parsing the events" do
    before(:each) do
      stub_request(:post, config.url).
        with(:body => request).
        to_return(:body => load_fixture(:fedex_delivery_response))
    end

    it "should set the time" do
      event = Trackerific::Fedex.new(package_id).track.events.last
      event.time.should == "2010-07-01 10:43"
    end

    it "should set the description" do
      event = Trackerific::Fedex.new(package_id).track.events.last
      event.description.should == "Delivered: Left at garage. Signature Service not requested."
    end

    it "should set the location" do
      event = Trackerific::Fedex.new(package_id).track.events.last
      event.location.should == "Gainesville, GA 30506 US"
    end
  end

  describe "When the package is out for delivery" do
    before(:each) do
      stub_request(:post, config.url).
        with(:body => request).
        to_return(:body => load_fixture(:fedex_out_for_delivery_response))
    end

    it "should assign the package id" do
      results = Trackerific::Fedex.new(package_id).track
      results.package_id.should eql(package_id)
    end

    it "should assign the summary" do
      package = Trackerific::Fedex.new(package_id).track
      package.description.should eql('On FedEx vehicle for delivery')
    end

    it "should not say the package has been delivered" do
      package = Trackerific::Fedex.new(package_id).track
      package.delivered.should be_false
    end
  end

  describe "When the server returns an error" do
    before(:each) do
      stub_request(:post, config.url).
        with(:body => request).
        to_return(:body => load_fixture(:fedex_error_response))
    end

    it "should raise an error" do
      lambda { 
        Trackerific::Fedex.new(package_id).track
      }.should raise_error(Trackerific::ServiceError, 'Invalid tracking numbers.   Please check the following numbers and resubmit.')
    end
  end
end
