# HttpConnect

A minimal Rest client that uses around the ruby Net::Http library to make requests. It features a simple interface for making Web requests. It has been written and tested on an environment using ruby 2.0 or later.

## Features

Currently the following HTTP verbs are supported

* POST
* GET
* DELETE
* PUT

Also it handle both https and http and one can use the basic authentication mode against a web resource
that accepts basic authentication mode.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_connect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_connect

## Usage

Some unit tests have been provided as examples. These unit tests are done against the 
[Hubtel Integration Platform APIs](https://developers.hubtel.com/).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/http_connect. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HttpConnect project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/http_connect/blob/master/CODE_OF_CONDUCT.md).
