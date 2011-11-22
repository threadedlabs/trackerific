require 'ostruct'

module Trackerific
  module Parsers
    class Ontrac
      def initialize(html)
        @doc = Nokogiri::HTML.parse(html)
      end

      def delivery_status
        info[:delivery_status]
      end

      def history
        events = @doc.xpath('//body/div/table[2]/tr/td[2]/div/table/tr/td/div/table[2]/tr/td/table/tr').inject([]) do |events, row|
          description =  row.at_xpath('./td[1]').content.strip.chomp.titleize
          timestamp = row.at_xpath('./td[2]').content.strip.chomp.gsub(/\s{2,}/, ' ')
          location = row.at_xpath('./td[3]').content.strip.chomp

          events << OpenStruct.new(:description => description, :timestamp => timestamp, :location => location)
          events
        end

        events.shift
        events
      end

      private
      def info
        @doc.xpath('//body/div/table[2]/tr/td[2]/div/table/tr/td/div/table[1]/tr/td/table/tr').inject({}) do |attrs, row|
          name = symbolize row.at_xpath('./td[1]').content.downcase
          value = row.at_xpath('./td[2]').content.strip.chomp.gsub(/\s{2,}/, ' ')

          attrs.merge({name.to_sym => value})
        end
      end

      def symbolize(string)
        string.strip.chomp.gsub(':', '').gsub(/\s+/, '_')
      end
    end
  end
end
