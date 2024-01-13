# Pry::Cyrano

Autocorrect typo in your Pry REPL.

This small Pry plugin captures exceptions and deduces the command based on your database information.

Eg:
```ruby
UserAccoint.last
# Will run the following command UserAccount.last
=>
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pry-cyrano

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pry-cyrano

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Troubleshooting

Pry-cyrano is linked to your development database. During initialization, it will attempt to establish a connection to retrieve the tables available in your project. It will fetch the information for the development environment from the `database.yml` file.

### Unreadable database URL (URI::InvalidURIError)

If the database connection string is not readable, the gem will be unable to establish a connection. If you encounter such an issue, make sure to add a `DATABASE_URL` variable to your `.env` file with the easily readable URL of your database.

### Unreadable connection pool (ActiveRecord::ConnectionTimeoutError)

If the number of connections in your pool is not readable, you may encounter an `ActiveRecord::ConnectionTimeoutError`. If you experience this issue, make sure to add a `DATABASE_POOL` variable to your `.env` file.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pry-cyrano. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pry-cyrano/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pry::Cyrano project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pry-cyrano/blob/master/CODE_OF_CONDUCT.md).
