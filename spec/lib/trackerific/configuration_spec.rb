require 'spec_helper'

describe "Trackerific.configuration" do
  describe "Configuring UPS" do
    subject { Trackerific.configuration.ups }

    it { should respond_to(:key=) }
    it { should respond_to(:key) }

    it { should respond_to(:user_id=) }
    it { should respond_to(:user_id) }

    it { should respond_to(:password=) }
    it { should respond_to(:password) }

    it { should respond_to(:url=) }
    it { should respond_to(:url) }

    its(:url) { should eql('https://wwwcie.ups.com/ups.app/xml') }
  end

  describe "Configuring Fedex" do
    subject { Trackerific.configuration.fedex }

    it { should respond_to(:account=) }
    it { should respond_to(:account) }

    it { should respond_to(:meter=) }
    it { should respond_to(:meter) }

    it { should respond_to(:url=) }
    it { should respond_to(:url) }

    its(:url) { should eql('https://gateway.fedex.com/GatewayDC') }
  end

  describe "Configuring USPS" do
    subject { Trackerific.configuration.usps }

    it { should respond_to(:user_id=) }
    it { should respond_to(:user_id) }

    it { should respond_to(:url=) }
    it { should respond_to(:url) }

    its(:url) { should eql('http://testing.shippingapis.com/ShippingAPITest.dll') }
  end
end
