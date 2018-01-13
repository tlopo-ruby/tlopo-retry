source 'https://rubygems.org'

# Specify your gem's dependencies in tlopo-retry.gemspec
gemspec

group :test do
  gem 'simplecov', '~> 0.12.0'
  gem 'coveralls', '~> 0.8.17'
end

if RUBY_VERSION > '2.1.0'
  group :perf do
    gem 'memory_profiler', '~> 0.9.8'
  end
end
