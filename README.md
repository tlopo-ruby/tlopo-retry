# tlopo-retry
[![Gem Version](https://badge.fury.io/rb/tlopo-retry.svg)](http://badge.fury.io/rb/tlopo-retry)
[![Build Status](https://travis-ci.org/tlopo-ruby/tlopo-retry.svg?branch=master)](https://travis-ci.org/tlopo-ruby/tlopo-retry)
[![Code Climate](https://codeclimate.com/github/tlopo-ruby/tlopo-retry/badges/gpa.svg)](https://codeclimate.com/github/tlopo-ruby/tlopo-retry)
[![Dependency Status](https://gemnasium.com/tlopo-ruby/tlopo-retry.svg)](https://gemnasium.com/tlopo-ruby/tlopo-retry)
[![Coverage Status](https://coveralls.io/repos/github/tlopo-ruby/tlopo-retry/badge.svg?branch=master)](https://coveralls.io/github/tlopo-ruby/tlopo-retry?branch=master)

A reusable retry mechanism which supports timeout, cleanup and fork

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tlopo-retry'
```

And then execute:

```Bash
bundle
```

Or install it yourself as:

```Bash
gem install tlopo-retry
```

## Usage

Simple retry usage 

```ruby
# That will retry 3 times with no timeout and 1 second interval
Tlopo::Retry.retry do 
  TCPSocket.new('www.google.co.uk','8080').close
end
```
Full options
```ruby
require 'logger'
require 'socket'

# Enable logging
ENV['TLOPO_LOG_LEVEL'] = 'debug' 

require 'tlopo/retry'

Tlopo::Retry.retry({
  desc: 'check if port 8080 is open on www.google.co.uk',
  tries: 2,
  interval: 5,
  timeout: 1,
  cleanup: proc { p 'Run your cleanup code here'}
}) do 
  TCPSocket.new('www.google.co.uk','8080').close
end
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/kubeclient/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Test your changes with `rake test rubocop`, add new tests if needed.
4. If you added a new functionality, add it to README
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request

## Tests

This library is tested with Minitest.
Please run all tests before submitting a Pull Request, and add new tests for new functionality.

Running tests:
```ruby
rake test
```
