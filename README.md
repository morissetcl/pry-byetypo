# PRY-BYETYPO

Autocorrects typos in your Pry console.

This small Pry plugin captures exceptions that may arise from typos and deduces the correct command based on your database information and session history.

#### Before

```ruby
[1] pry(main)> result = 1
=> 1
[2] pry(main)> resilt
NameError: undefined local variable or method `resilt' for main:Object
from (pry):2:in `__pry__'
```

#### After

```ruby
[1] pry(main)> result = 1
=> 1
[2] pry(main)> resilt
E, [2024-01-31T17:11:16.344161 #3739] ERROR -- : undefined local variable or method `resilt' for main:Object
I, [2024-01-31T17:11:16.344503 #3739]  INFO -- : Running: result
=> 1
```

> [!NOTE]
> At present, this plugin is not ORM-agnostic; instead, it specifically requires ActiveRecord.

## Installation


Install the gem and add to the application's Gemfile, under the `development` group, by executing:

```
bundle add pry-byetypo
```

If bundler is not being used to manage dependencies, install the gem by executing:

```
gem install pry-byetypo
```

## Usage

1. Open a PRY console.
2. Start your daily work.
3. Let `pry-byetypo` remove frictions. 🚀

## Byetypo dictionary

When you open a new Pry console, the gem will generate a `byetypo_dictionary.pstore` file containing four pieces of information:

- A list of the ActiveRecord models in your application (e.g. `User`, `Account`).
- A list of the ActiveRecord associations in your application (e.g. `user`, `users`, `account`, `accounts`).
- Unique identifiers for each active Pry instance, populated with the variable history of the current session. (e.g. `result = 1` will store `result`)
- A timestamp representing the last time the `byetypo_dictionary` was updated. (by default updated every week).

This file is generated at the root of your application by default. If you want to update its location, you can configure the path by adding a `BYETYPO_STORE_PATH` entry in your `.env` file.

## Captured exceptions

### NameError - undefined local variable or method

This error occurs when you mispelled a variable in your REPL. The gem will catch that exception and will try find the closest matches. If so, it will run the command with the (potential) corrected variable.

##### Before

```ruby
[1] pry(main)> result = 1
=> 1
[2] pry(main)> resilt
NameError: undefined local variable or method `resilt' for main:Object
from (pry):2:in `__pry__'
```

##### After

```ruby
[1] pry(main)> result = 1
=> 1
[2] pry(main)> resilt
E, [2024-01-31T17:11:16.344161 #3739] ERROR -- : undefined local variable or method `resilt' for main:Object
I, [2024-01-31T17:11:16.344503 #3739]  INFO -- : Running: result
=> 1
```

### NameError - uninitialized constant

This error occurs when you mispelled a model in your REPL. The gem will catch that exception and will try find the closest matches. If so, it will run the command with the (potential) corrected model.

##### Before

```ruby
[2] pry(main)> Usert.last
NameError: uninitialized constant Usert
from (pry):2:in `__pry__'
[3] pry(main)>
```

##### After

```ruby
[1] pry(main)> Usert.last
I, [2024-01-13T20:00:16.280710 #694]  ERROR -- : uninitialized constant Usert
I, [2024-01-13T20:00:16.281237 #694]  INFO -- : Running: User.last
=> #<User id: 1, email: "yo@email.com">
```

### ActiveRecord::ConfigurationError

Raised when association is being configured improperly or user tries to use offset and limit together with `ActiveRecord::Base.has_many` or `ActiveRecord::Base.has_and_belongs_to_many` associations.
This plugin will look into the `byetypo_dictionary` file to find the closest match and run the correct query.

##### Before

```ruby
[6] pry(main)> User.joins(:group).where(groups: { name: "Landlord" }).last
ActiveRecord::ConfigurationError: Can't join 'User' to association named 'group'; perhaps you misspelled it?
```

##### After

```ruby
[1] pry(main)> User.joins(:group).where(groups: { name: "Landlord" })
I, [2024-01-13T22:45:16.297811 #1079]  ERROR -- : ActiveRecord::ConfigurationError: Can't join 'User' to association named 'group'; perhaps you misspelled it?
I, [2024-01-13T22:45:16.297972 #1079]  INFO -- : Running: User.joins(:groups).where(groups: { name: "Landlord" })
2024-01-13 22:45:16.319544 D [1079:9200 log_subscriber.rb:130] ActiveRecord::Base --   User Load (1.6ms)  SELECT "users".* FROM "users" INNER JOIN "user_groups" ON "user_groups"."user_id" = "users"."id" INNER JOIN "groups" ON "groups"."id" = "user_groups"."group_id" WHERE "users"."deleted_at" IS NULL AND "groups"."name" = $1  [["name", "Landlord"]]
=> []
```

### ActiveRecord::StatementInvalid

The query attempts to reference columns or conditions related to a table, but the table is not properly included in the FROM clause.
This plugin will look into the `byetypo_dictionary` file to find the closest match and run the correct query.

##### Before

```ruby
[1] pry(main)> User.joins(:groups).where(grous: { name: "Landlord" }).last
ActiveRecord::StatementInvalid: PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "grous"
LINE 1: ..."group_id" WHERE "users"."deleted_at" IS NULL AND "grous"."n...
```

##### After

```ruby
1] pry(main)> User.joins(:groups).where(grous: { name: "Landlord" }).last
I, [2024-01-14T23:50:49.273043 #1248]  ERROR -- : ActiveRecord::StatementInvalid: PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "grous"
I, [2024-01-14T23:50:49.273177 #1248]  INFO -- : Running: User.joins(:groups).where(groups: { name: "Landlord" }).last
2024-01-14 23:50:49.281956 D [1248:9200 log_subscriber.rb:130] ActiveRecord::Base --   User Load (2.1ms)  SELECT "users".* FROM "users" INNER JOIN "user_groups" ON "user_groups"."user_id" = "users"."id" INNER JOIN "groups" ON "groups"."id" = "user_groups"."group_id" WHERE "users"."deleted_at" IS NULL AND "groups"."name" = $1 ORDER BY "users"."id" DESC LIMIT $2  [["name", "Landlord"], ["LIMIT", 1]]
```

## Troubleshooting

Pry-byetypo is linked to your development database. During initialization, it will attempt to establish a connection to retrieve the tables available in your project. It will fetch the information for the development environment from the `database.yml` file.

#### Unreadable database URL (URI::InvalidURIError)

If the database connection string is not readable, the gem will be unable to establish a connection. If you encounter such an issue, make sure to add a `DATABASE_URL` variable to your `.env` file with the easily readable URL of your database.

#### Unreadable connection pool (ActiveRecord::ConnectionTimeoutError)

If the number of connections in your pool is not readable, you may encounter an `ActiveRecord::ConnectionTimeoutError`. If you experience this issue, make sure to add a `DATABASE_POOL` variable to your `.env` file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/morissetcl/pry-byetypo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/morissetcl/pry-byetypo/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pry::Byetypo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/morissetcl/pry-byetypo/blob/master/CODE_OF_CONDUCT.md).
