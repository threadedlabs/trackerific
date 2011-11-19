require 'spec_helper'

describe Trackerific::UPS do
  let(:package_id) { '1Z12345E0291980793' }
  let(:config) { subject.config }

  subject { Trackerific::UPS }

  it "should be able to track ups ground packages" do
    subject.tracks?("1Z12345E0291980793").should be_true
  end

  describe "using the ups API" do
    before(:each) do
      config.key = 'a-key'
      config.user_id = 'user-id'
      config.password = 'the-password'
    end

    let(:request) do
      %Q{
        <AccessRequest>
          <AccessLicenseNumber>#{config.key}</AccessLicenseNumber>
          <UserId>#{config.user_id}</UserId>
          <Password>#{config.password}</Password>
        </AccessRequest>
        <TrackRequest>
          <Request>
            <RequestAction>Track</RequestAction>
            <RequestOption>activity</RequestOption>
          </Request>
          <TrackingNumber>#{package_id}</TrackingNumber>
        </TrackRequest>
      }.split("\n").map(&:strip).join('')
    end

    describe "When the server returns a delivery response" do
      before(:each) do
        stub_request(:post, "#{config.url}/Track").
          with(:body => request).
          to_return(:body => load_fixture(:ups_delivery_response))
      end

      it "should assign the package id" do
        package = Trackerific::UPS.new(package_id).track
        package.package_id.should eql(package_id)
      end

      it "should parse all the events" do
        package = Trackerific::UPS.new(package_id).track
        package.events.size.should eql(1)
      end

      it "should set the description" do
        package = Trackerific::UPS.new(package_id).track
        package.description.should eql('Delivered')
      end

      it "should should say the package is delivered" do
        package = Trackerific::UPS.new(package_id).track
        package.delivered.should be_true
      end
    end

    describe "When the server returns an error" do
      before(:each) do
        stub_request(:post, "#{config.url}/Track").
          with(:body => request).
          to_return(:body => load_fixture(:ups_error_response))
      end

      it "should raise an error" do
        lambda { 
          Trackerific::UPS.new(package_id).track
        }.should raise_error(Trackerific::ServiceError)
      end
    end
  end

end
