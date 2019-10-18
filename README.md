# AtlasScientific

AtlasScientific is an abstraction layer [atlas scientific](https://www.atlas-scientific.com) devices.
Any atlas scientific can be used, although the checked ones are supported with easier and optimized APIs.

- [x] [PH circuit](https://www.atlas-scientific.com/product_pages/circuits/ezo_ph.html)
- [x] [EC circuit](https://www.atlas-scientific.com/product_pages/circuits/ezo_ec.html)
- [x] [Temperature circuit](https://www.atlas-scientific.com/product_pages/circuits/ezo_rtd.html)
- [ ] [ORP circuit](https://www.atlas-scientific.com/product_pages/circuits/ezo_orp.html)
- [ ] [Dissolved oxygen circuit](https://www.atlas-scientific.com/dissolved-oxygen.html)
- [ ] [Carbon dioxide Sensor (CO2)](https://www.atlas-scientific.com/product_pages/probes/ezo-co2.html)
- [ ] [Pressure Sensor](https://www.atlas-scientific.com/product_pages/pressure/ezo-prs.html)
- [ ] [Flow Meter Totalizer](https://www.atlas-scientific.com/product_pages/circuits/ezo_flow.html)
- [ ] [Color Sensor](https://www.atlas-scientific.com/product_pages/probes/ezo-rgb.html)

_Disclaimer: This library only supports `i2c` mode._

**NOTE**: Although they aren't "supported" you can still use this library to access them easily. See [usage](#usage).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'atlas_scientific'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install atlas_scientific

## Usage

There's a base class for any AtlasScientific device which can be used like this:

```ruby
require 'atlas_scientific'

# The path parameter will automatically look for the first `i2c-*` device in your `/dev` folder.
# But you can also explicitly pass it as an argument:
pressure = AtlasScientific::I2CDevice.new(0x6A, path: '/dev/i2c-1')
pressure.take_reading # => 12.3

# enable/disables the LED
pressure.l # => "?"

# A lot of "default" commands are support through methods, e.g. cal, factory, i, find, o, status etc.
pressure.i => "?I,psi"

# If there happens to be a command which is not implemented as a method, you can call "execute":
# This command will change the output of the pressure unit sensor as specified in the datasheet.
# On page 46: https://www.atlas-scientific.com/_files/_datasheets/_pressure/EZO-PRS-Datasheet.pdf
pressure.execute('u', 'bar')
```

There are also better abstraction classes for the checked circuit/probes at the top:

```ruby
# Automatically takes the default I2C address of the PH circuit (0x63)
# The default i2c addresses can be found in the datasheets of the circuits
# E.g. PH: https://www.atlas-scientific.com/_files/_datasheets/_circuit/pH_EZO_Datasheet.pdf
ph = AtlasScientific::PH.new
ph.slope # => 7.58
ph.take_reading # => 7.58
ph.take_reading_with_temperature_compensation(29.3) # => 7.49
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/siegy22/atlas_scientific. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AtlasScientific project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/siegy22/atlas_scientific/blob/master/CODE_OF_CONDUCT.md).
