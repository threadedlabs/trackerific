require 'spec_helper'

describe Trackerific do
  subject { Trackerific }

  describe "Trackerific.service" do
    it "should find a service if on #tracks?" do
      Trackerific::USPS.stub(:tracks?).with('package-id').and_return(false)
      Trackerific::Fedex.stub(:tracks?).with('package-id').and_return(false)
      Trackerific::UPS.stub(:tracks?).with('package-id').and_return(true)

      subject.service('package-id').should eql(Trackerific::UPS)
    end

    it "should return nil if no service #tracks?" do
      Trackerific::USPS.stub(:tracks?).with('package-id').and_return(false)
      Trackerific::Fedex.stub(:tracks?).with('package-id').and_return(false)
      Trackerific::UPS.stub(:tracks?).with('package-id').and_return(false)

      subject.service('package-id').should be_nil
    end
  end

  describe "Trackerific.track" do
    it "should find use the service to track the package" do
      Trackerific::USPS.stub(:tracks?).with('package-id').and_return(false)
      Trackerific::Fedex.stub(:tracks?).with('package-id').and_return(false)
      Trackerific::UPS.stub(:tracks?).with('package-id').and_return(true)

      Trackerific::UPS.should_receive(:track).with('package-id')

      subject.track 'package-id'
    end

    it "should raise an error when there is no service" do
      Trackerific::USPS.stub(:tracks?).with('package-id').and_return(false)
      Trackerific::Fedex.stub(:tracks?).with('package-id').and_return(false)
      Trackerific::UPS.stub(:tracks?).with('package-id').and_return(false)

      lambda {
        subject.track 'package-id'
      }.should raise_error(Trackerific::UnknownPackageId)
    end
  end
end
