# Record Store

Store records in your database using Sequel

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'record_store'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install record_store

## Usage

If you have an application where you are working with records as hashes and you would like store them in your database using Sequel, this gem can help make that happen. To use Record Store, you should subclass the `RecordStore` class at least once in your application. If for example you already have a reference to a Sequel database stored in a constant called `DB`, then you would do something lke this:

```ruby
class Store < RecordStore
  def self.database
    DB
  end
end
```

Then for each table you want to store records in, you subclass that class:

```ruby
class UserStore < Store
end
```

You can now store records in the `users` table like this:

```ruby
UserStore << { first_name: 'Paul', last_name: 'Barry' }
```

You can also add validations to your store, like this:

```ruby
class UserStore < Store
  required_attributes :first_name, :last_name
end
```

If you try to store a record without values for those attributes, you will get an error:

```ruby
UserStore << {}
 # => { errors: ["First Name is required", "Last Name is required"]}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/record_store/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
