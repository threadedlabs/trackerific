require 'spec_helper'

describe Trackerific::Ontrac do
  let(:package_id) { 'C10996669909317' }

  subject { Trackerific::Ontrac }

  it "should be able to track C-14 number" do
    subject.tracks?(package_id).should be_true
  end

  describe "track" do
    let(:html) { 'this-html-comes-from-their-site' }
    let(:history) { mock('Struct', :timestamp => '5pm', :description => 'Delivered', :location => 'Home') }
    let(:info) { mock('Info', :history => [history], :delivery_status => 'DELIVERED') }

    before(:each) do
      Trackerific::Fetchers::Ontrac.should_receive(:fetch).with(package_id).and_return(html)
      Trackerific::Parsers::Ontrac.should_receive(:new).with(html).and_return(info)
    end

    it "should set the package id" do
      package = subject.track package_id
      package.package_id.should == package_id
    end

    it "should create a delivered package when the status is DELIVERED" do
      info.stub(:delivery_status).and_return('DELIVERED')

      package = subject.track package_id
      package.delivered.should be_true
    end

    it "should create a ofd package when the status is OUT FOR DELIVERY" do
      info.stub(:delivery_status).and_return('OUT FOR DELIVERY')

      package = subject.track package_id
      package.out_for_delivery.should be_true
    end

    it "should build the events from the history" do
      package = subject.track package_id
      event = package.events.first

      event.time.should == history.timestamp
      event.description.should == history.description
      event.location.should == history.location
    end
  end
end
