require 'spec_helper'

describe Trackerific::Fedex do
  let(:package_id) { "183689015000001" }
  let(:config) { subject.config }

  subject { Trackerific::Fedex }

  it "should be able to track fedex ground packages" do
    subject.tracks?("491428716545").should be_true
  end

  it "should be able to track fedex express packages" do
    subject.tracks?("183689015000001").should be_true
  end

  describe "using the Fedex API" do
    before(:each) do
      config.meter = 'meter'
      config.account = 'account-id'
    end

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

    describe "When the server returns correctly" do
      before(:each) do
        stub_request(:post, config.url).
          with(:body => request).
          to_return(:body => load_fixture(:fedex_success_response))
      end

      it "should assign the package id" do
        results = Trackerific::Fedex.new(package_id).track
        results.package_id.should eql(package_id)
      end

      it "should assign the summary" do
        results = Trackerific::Fedex.new(package_id).track
        results.summary.should be_a(String)
      end

      it "should parse all the events" do
        results = Trackerific::Fedex.new(package_id).track
        results.events.size.should eql(4)
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
end
