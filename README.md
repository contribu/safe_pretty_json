# SafePrettyJson

SafePrettyJson is a fast and safe alternative to `JSON.pretty_generate(JSON.parse(input))`.

Safe means that the meaning of JSON is not modified (floating point reporesentation and key order)

## Features

- 20x Fast compared to `JSON.pretty_generate(JSON.parse(input))`
- Key order is not modifed
- Floating point representation is not modifed `'{ "a": 1.11111111111111111111111111111111111111111 }'`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'safe_pretty_json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safe_pretty_json

## Usage

### Basic

```ruby
require 'safe_pretty_json'
SafePrettyJson.prettify('{ "a": 1 }')
# "{\n  \"a\": 1\n}"
```

SafePrettyJson.prettify doesn't validate if the input string is valid json.
If the input is invalid, prettify returns a string whose contents are undefined.

### Rails (Rack Middleware)

Add following to application.rb.
This enables response body json prettification only when content-type is application/json.

```ruby
config.middleware.use SafePrettyJson::RackMiddleware
```

## Benchmark

```bash
ruby bench/bench.rb
```

- simple: JSON.pretty_generate(JSON.parse(input))
- safe_pretty_json: this gem

```
                 user     system      total        real
simple       9.840000   0.004000   9.844000 (  9.844245)
safe_pretty_json  0.484000   0.000000   0.484000 (  0.485056)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/safe_pretty_json. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SafePrettyJson project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/safe_pretty_json/blob/master/CODE_OF_CONDUCT.md).
