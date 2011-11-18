require 'spec_helper'

describe Trackerific::USPS do
  let(:package_id) { 'EJ958083578US' }
  let(:config) { subject.config }

  subject { Trackerific::USPS }

  it "should be able to E-format packages" do
    subject.tracks?("EJ958083578US").should be_true
  end

  it "should be able to track credit like package numbers" do
    subject.tracks?("9102 9010 0134 3104 0819 19").should be_true
  end

  describe "using the ups API" do
    before(:each) do
      config.user_id = 'user-id'
    end

    let(:request) do
      {
        :API => 'TrackV2', 
        :XML => %Q{
          <TrackRequest USERID="#{config.user_id}">
            <TrackID ID="#{package_id}"/>
          </TrackRequest>
        }.split("\n").map(&:strip).join('')
      }.to_query
    end

    describe "When the server returns correctly" do
      before(:each) do
        stub_request(:get, "#{config.url}?#{request}").
          to_return(:body => load_fixture(:usps_success_response))
      end

      it "should assign the package id" do
        results = Trackerific::USPS.new(package_id).track
        results.package_id.should eql(package_id)
      end

      it "should parse all the events" do
        results = Trackerific::USPS.new(package_id).track
        results.events.size.should eql(3)
      end
    end

    describe "When the server returns an error" do
      before(:each) do
        stub_request(:get, "#{config.url}?#{request}").
          to_return(:body => load_fixture(:usps_error_response))
      end

      it "should raise an error" do
        lambda { 
          Trackerific::USPS.new(package_id).track
        }.should raise_error(Trackerific::ServiceError, 'Missing value for To Phone number.')
      end
    end
  end
end
