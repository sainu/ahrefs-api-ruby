# AhrefsApi

Ahrefs API client library, written in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ahrefs-api-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ahrefs-api-ruby

## Setup

You should get access token for API [Profile - Ahrefs API](https://ahrefs.com/api/profile).

## Usage

```rb
require 'ahrefs_api'

AhrefsApi.configure do |config|
  config.token = 'Your access token'  # required
  config.timeout = 30                 # optional - request timeout(s)
end

client = AhrefsApi::Client.new
client.target = 'example.com'
client.mode_subdomains
      .output_json
      .from_backlinks_new_lost_counters
      .where('date', '>', Date.today - 1.months)
      .order(new: :desc)
response = client.send_get
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sainuio/ahrefs-api-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ahrefs::Api::Ruby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sainuio/ahrefs-api-ruby/blob/master/CODE_OF_CONDUCT.md).
