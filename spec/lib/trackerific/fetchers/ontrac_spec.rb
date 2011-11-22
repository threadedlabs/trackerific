require 'spec_helper'

describe Trackerific::Fetchers::Ontrac do
  it "should use mechnize to find the HTML" do
    browser = mock('Agent')
    link = mock('Link')

    Mechanize.stub(:new).and_return(browser)

    browser.should_receive(:get).with("http://www.ontrac.com/trackingres.asp?tracking_number=C10996669909317").and_return(browser)
    browser.should_receive(:link_with).with(:text => "DETAILS").and_return(link)
    link.stub_chain(:click, :body, :to_s).and_return('html')

    Trackerific::Fetchers::Ontrac.fetch("C10996669909317").should eql('html')
  end
end
