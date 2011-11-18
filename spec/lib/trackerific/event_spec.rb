require 'spec_helper'

describe Trackerific::Event do
  let(:time) { Time.now }

  subject do
    Trackerific::Event.new({
      :time => time,
      :description => 'delivered',
      :location => '1337 leet street'
    })
  end

  its(:time) { should eql(time) }

  its(:description) { should eql('delivered') }

  its(:location) { should eql('1337 leet street') }
end
