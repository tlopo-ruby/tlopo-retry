# tlopo-retry
A reusable retry mechanism which supports timeout, cleanup and fork


## Contributing

1. Fork it ( https://github.com/[my-github-username]/kubeclient/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Test your changes with `rake test rubocop`, add new tests if needed.
4. If you added a new functionality, add it to README
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request

## Tests

This client is tested with Minitest and also uses VCR recordings in some tests.
Please run all tests before submitting a Pull Request, and add new tests for new functionality.

Running tests:
```ruby
rake test
```
