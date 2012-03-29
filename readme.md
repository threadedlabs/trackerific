# Trackerific

No nonsense package tracking for Ruby.

Implemented services:

* UPS
* Fedex
* USPS
* Ontrac

## Configuration

To take advantage of Trackerific's automatic service discovery, you will need to
configure your credentials for each service.

```ruby
require 'trackerific'
Trackerific.configure do |config|
  config.fedex  :account  => 'account',
                :meter    => '123456789'

  config.ups    :key      => 'key',
                :user_id  => 'userid',
                :password => 'secret'

  config.usps   :user_id  => 'userid',
                :use_city_state_lookup => true
end
```
  
For USPS packages, the option `:use_city_state_lookup` defaults to false, and will
only work if you have access to USPS's CityStateLookup API. If you can enable
it, this feature will provide the location for USPS package events.

## Use

```ruby
# Trackerific will do its best to find the service for you.
Trackerific.track 'a-tracking-number' 

# Use a specific one if you like
Trackerific::Fedex.track 'a-tracking-number'
```

## Standard Result Format

```javascript
{
  package_id: 'XXXXXXXXXX',
  delivered: true,
  out_for_delivery: true,
  description: 'Package Delivered',
  events: [
    {
        time: '2012-03-03 3:12 PM'
        description: 'Package delivered.',
        location: 'SANTA MARIA, CA'
    },
    {
        time: '2010-03-03 6:12 PM'
        description: 'Package scanned.',
        location: 'SANTA BARBARA, CA'
    },
    {
        time: '2019-03-03 6:12 PM'
        description: 'Package picked up for delivery.',
        location: 'LOS ANGELES, CA'
    }
  ]
}
```

## Testing

A fake service is included as well. You can use that for testing:

```ruby
Trackerific.track 'XXXXXXXXXX'
```

## Contributing to trackerific

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Travis Haynes. See LICENSE.txt for
further details.

