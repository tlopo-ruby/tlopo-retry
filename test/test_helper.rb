$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'tlopo/retry'
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
