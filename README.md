# Nummernkreis

[![Build Status](https://travis-ci.org/frontrunnerio/nummernkreis.svg?branch=master)](https://travis-ci.org/frontrunnerio/nummernkreis)

This gem implements a number range ("Nummernkreis" in German) which is very common for German documents like invoices where the invoice number is not just a number sequence but also includes date components.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nummernkreis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nummernkreis

## Usage

When generating a new number range you need to specify its pattern.
The following components are possible:

```
  yyyy: year with full 4 digits (e.g. 1980 or 2019)
    yy: year with two digits (e.g. 19 for 2019)
    mm: month starting with 1 (e.g. 02 for February)
    dd: day of the month starting with 1 (e.g. 01 for first day)
    - : dash separator
    # : part of the sequence that will be incremented.
```

Examples (assuming current date is 2019-04-15):

```ruby
  Nummernkreis.new('####').to_s
  # '0001'

  Nummernkreis.new('yymmdd-##').to_s
  # '190425-01'

  Nummernkreis.new('yymmdd-##').next
  # '190425-02'

  Nummernkreis.new('yymmdd-##').parse('181231-04').next
  # '181231-05'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/frontrunnerio/nummernkreis.
You can just use Gitpod and start hacking.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io#https://github.com/frontrunnerio/nummernkreis)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

