# MongoidSnappy

Allow string attributes in Mongoid to be compressed with Snappy

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid_snappy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_snappy

## Usage

MongoDB doesn't have built in support for data compression.

See https://jira.mongodb.org/browse/SERVER-164

So in meantime the solution is application level compression.

Define a field of type Mongoid::Snappy

```ruby
class MyModel
  field :long_text, type: Mongoid::Snappy
end
```

Strings are transparently compressed and decompressed:

```ruby
m = MyModel.new
m.long_text = 'a very long string here'
m.long_text # -> 'a very long string here'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
