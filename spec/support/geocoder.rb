addresses = [
    ['Tromsø',
     [{
          latitude: 40.09846115112305,
          longitude: -83.01747131347656,
          address: 'Worthington, OH',
          state: 'New York',
          state_code: 'NY',
          country: 'United States',
          country_code: 'US'
      }]],
    ['Oslo',
     [{
          latitude: 40.09846115112305,
          longitude: -83.01747131347656,
          address: 'Worthington, OH',
          state: 'New York',
          state_code: 'NY',
          country: 'United States',
          country_code: 'US'
      }]],
]

Geocoder.configure(lookup: :test)
addresses.each {|addr| Geocoder::Lookup::Test.add_stub(addr[0], addr[1])}