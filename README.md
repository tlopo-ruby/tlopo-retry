# tlopo-retry
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
Tlopo::Retry.retry({
  desc: 'check if port 8080 is open on www.google.co.uk',
  tries: 5,
  interval: 30,
  timeout: 5
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
