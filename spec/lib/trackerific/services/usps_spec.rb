require 'spec_helper'

describe Trackerific::USPS do
  before(:each) do
    config.user_id = 'user-id'
  end

  let(:package_id) { 'EJ958083578US' }
  let(:config) { subject.config }

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

  subject { Trackerific::USPS }

  it "should be able to E-format packages" do
    subject.tracks?("EJ958083578US").should be_true
  end

  it "should be able to track credit like package numbers" do
    subject.tracks?("9102 9010 0134 3104 0819 19").should be_true
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

  describe "Parsing the results" do
    before(:each) do
      stub_request(:get, "#{config.url}?#{request}").
        to_return(:body => load_fixture(:usps_success_response))
    end

    it "should handle the time" do
      event = Trackerific::USPS.new(package_id).track.events.first 
      event.time.should == 'May 29 9:55 am'
    end

    it "should handle the location" do
      event = Trackerific::USPS.new(package_id).track.events.first 
      event.location.should == 'Edgewater, NJ 07020'
    end

    it "should handle the description" do
      event = Trackerific::USPS.new(package_id).track.events.first 
      event.description.should == 'Accept or pickup'
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
