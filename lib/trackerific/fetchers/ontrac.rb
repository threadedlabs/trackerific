require 'mechanize'

module Trackerific
  module Fetchers
    class Ontrac
      def self.fetch(tracking_number)
        browser = Mechanize.new
        page = browser.get "http://www.ontrac.com/trackingres.asp?tracking_number=#{tracking_number}"
        page.link_with(:text => "DETAILS").click.body.to_s
      end
    end
  end
end
