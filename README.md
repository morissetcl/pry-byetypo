# Pry::Cyrano

TODO: Delete this and the text below, and describe your gem

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/pry/cyrano`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Troubleshooting

Pry-cyrano is tied to your development database. During the initialization it will try to establish a connection to fetch the tables available in your project. It will fetch the information for the `development` environment in the `database.yml` file

### Unreadable database URL (URI::InvalidURIError)

If the database is not a readable string the gem will not able to establish a connection. If you face such problem be sure to add in your .env a `DATABASE_URL` variable with the url of your database easily readable.

### Unreadable connection pool (ActiveRecord::ConnectionTimeoutError)

If your number of connection pool is not readable you will face a `ActiveRecord::ConnectionTimeoutError`. If you face such problem be sure to add in your .env a `DATABASE_POOL` variable.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pry-cyrano. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pry-cyrano/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pry::Cyrano project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pry-cyrano/blob/master/CODE_OF_CONDUCT.md).
