require 'spec_helper'

describe Trackerific::Package do
  let(:one_week_from_now) { Time.now + 60*60*24*7 }

  subject do
    Trackerific::Package.new({
      :package_id => '123456789',
      :summary => 'delivered',
      :events => [],
      :weight => '45kg',
      :via => 'ground',
      :estimated_arrival => one_week_from_now
    })
  end

  its(:package_id) { should eql('123456789') }

  its(:summary) { should eql('delivered') }

  its(:events) { should eql([]) }

  its(:weight) { should eql('45kg') }

  its(:via) { should eql('ground') }

  its(:estimated_arrival) { should eql(one_week_from_now) }
end
