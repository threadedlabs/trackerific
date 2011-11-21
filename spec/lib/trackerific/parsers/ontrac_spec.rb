require 'spec_helper'

describe Trackerific::Parsers::Ontrac do
  let(:html) { load_fixture(:ontrac_html_response, :html) }

  subject { Trackerific::Parsers::Ontrac.new html }

  its(:delivery_description) { should eql('fd') }

  its(:delivery_status) { should eql('DELIVERED') }

  its(:delivery_time) { should eql('10/29/2011 1:59 PM') }

  describe "The history" do
    subject { Trackerific::Parsers::Ontrac.new(html).history }

    its(:size) { should == 5 }

    it "most recent event should be delivered" do
      event = subject.first
      event.description.should == 'Delivered'
      event.location.should == 'Sacramento'
      event.timestamp.should == "Oct 29 2011 1:59PM"
    end

    it "next one should be out for delivery" do
      event = subject[1]
      event.description.should == 'Out For Delivery'
      event.location.should == 'Sacramento'
      event.timestamp.should == "Oct 29 2011 6:59AM"
    end
  end
end
