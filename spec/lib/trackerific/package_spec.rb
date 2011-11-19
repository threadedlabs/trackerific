require 'spec_helper'

describe Trackerific::Package do
  let(:one_week_from_now) { Time.now + 60*60*24*7 }

  let(:event) { double('event', :description => 'look under mat') }

  subject do
    Trackerific::Package.new({
      :package_id => '123456789',
      :events => [event],
      :weight => '45kg',
      :via => 'ground',
      :estimated_arrival => one_week_from_now,
      :delivered => true
    })
  end

  its(:package_id) { should eql('123456789') }

  its(:description) { should eql(event.description) }

  its(:events) { should eql([event]) }

  its(:weight) { should eql('45kg') }

  its(:via) { should eql('ground') }

  its(:delivered) { should be_true }
end
