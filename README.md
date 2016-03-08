[![Build Status](https://travis-ci.org/CoolElvis/simple_rules.svg?branch=master)](https://travis-ci.org/CoolElvis/simple_rules)
[![Code Climate](https://codeclimate.com/github/CoolElvis/simple_rules/badges/gpa.svg)](https://codeclimate.com/github/CoolElvis/simple_rules)
[![Test Coverage](https://codeclimate.com/github/CoolElvis/simple_rules/badges/coverage.svg)](https://codeclimate.com/github/CoolElvis/simple_rules/coverage)
[![Issue Count](https://codeclimate.com/github/CoolElvis/simple_rules/badges/issue_count.svg)](https://codeclimate.com/github/CoolElvis/simple_rules)

# SimpleRules

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_rules'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_rules

## Usage

Define rule: 

```ruby
SimpleRules.can :some_action, SomeObject, error_message: 'Message' do |object, subject|
  subject.some_attr ==  object.some_attr
end
```

Checking action: 
```ruby
SimpleRules.can? :some_action, some_object, subject
```

Configuration:
```ruby
SimpleRules.configure do |config|
  config.raise_not_authorized = true
end
``` 
If raise_not_authorized is true then SimpleRules.can will raise SimpleRules:NotAuthorized exception with an error_message.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CoolElvis/simple_rules. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

