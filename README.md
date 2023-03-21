# ActiveRecord::Serializable

[![Gem Version](https://badge.fury.io/rb/active_record-serializable.svg)](https://rubygems.org/gems/active_record-serializable)
[![CI](https://github.com/gabynaiman/active_record-serializable/actions/workflows/ci.yml/badge.svg)](https://github.com/gabynaiman/active_record-serializable/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/gabynaiman/active_record-serializable/badge.svg?branch=master)](https://coveralls.io/github/gabynaiman/active_record-serializable?branch=master)
[![Code Climate](https://codeclimate.com/github/gabynaiman/active_record-serializable.svg)](https://codeclimate.com/github/gabynaiman/active_record-serializable)

Extension for ActiveRecord to get serializable and marshalizable models using Rasti::Model

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record-serializable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record-serializable

## Usage

```ruby
class User < ActiveRecord::Base
  has_one :avatar
  has_many :posts
end
```

### Basic
```ruby
user = User.find 1
user.to_serializable # ActiveRecord::Serializable::USER[id: 1, ...]
```

### Include relations
```ruby
user = User.find 1
user.to_serializable include: [:avatar, :posts] # ActiveRecord::Serializable::USER[id: 1, avatar: ActiveRecord::Serializable::AVATAR[...], posts: [ActiveRecord::Serializable::POST[...]]]
```

### Extended with methods
```ruby
class User < ActiveRecord::Base
  serializable_define_method :sorted_post_titles do
    posts.map(&:title).sort
  end
end

user = User.find 1
serializable = user.to_serializable(include: [:posts])
serializable.sorted_post_titles # ['Title 1', ...]
```

### Extended with modules
```ruby
module Helper
  def sorted_post_titles
    posts.map(&:title).sort
  end
end

class User < ActiveRecord::Base
  serializable_include Helper
end

user = User.find 1
serializable = user.to_serializable(include: [:posts])
serializable.sorted_post_titles # ['Title 1', ...]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gabynaiman/active_record-serializable.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

