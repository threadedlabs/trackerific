require 'spec_helper'

describe Trackerific::MockService do
  subject { Trackerific::MockService }

  specify("it should descend from Trackerific::Service") {
    Trackerific::MockService.superclass.should be Trackerific::Service
  }

  it "should be able to to simualate tracking a package" do
    subject.tracks?('XXXXXXXXXX').should be_true
  end

  it "should be able to simulate a bad tracking number" do
    subject.tracks?('XXXxxxxxxx').should be_true
  end

  describe :track do
    describe "When the tracking number is valid" do
      subject { Trackerific::MockService.track 'XXXXXXXXXX' }

      its(:package_id) { should eql('XXXXXXXXXX') }
      its(:summary) { should eql('At door step') }
      its(:events) { should be_a(Array) }
    end

    describe "When the tracking number is invalid" do
      it "should raise an error" do
        lambda { 
          subject.track('XXXxxxxxxx') 
        }.should raise_error(Trackerific::UnknownPackageId, /invalid/)
      end
    end
  end
end
