require 'spec_helper'

describe Trackerific::Details do
  subject do
    Trackerific::Details.new({
      :package_id => '123456789',
      :summary => 'delivered',
      :events => [],
      :weight => '45kg',
      :via => 'ground'
    })
  end

  its(:package_id) { should eql('123456789') }

  its(:summary) { should eql('delivered') }

  its(:events) { should eql([]) }

  its(:weight) { should eql('45kg') }

  its(:via) { should eql('ground') }
end
