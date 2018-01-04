require 'test_helper'

# ensure that it retries block
# ensure it times out
# ensure it forks
# ensure it raises unknown option
# ensure it calls cleanup

module Tlopo
  class RetryTest < Minitest::Test
    def setup
      @opts = {
        timeout: 10,
        desc: 'unit testing'
      }
    end

    def test_that_it_has_a_version_number
      refute_nil(::Tlopo::Retry::VERSION)
    end

    def test_that_it_retries
      count = 0
      begin
        Tlopo::Retry.retry(tries: 1, interval: 0.1) do
          count += 1
          raise 'whatever'
        end
      rescue RuntimeError => e
        p(e.message)
      end
      assert_equal(count, 2)
    end

    def test_that_it_times_out
      e = assert_raises Timeout::Error do
        Tlopo::Retry.retry(timeout: 1) { sleep 2 }
      end
      assert_equal('execution expired', e.message)
    end

    def test_that_it_forks
      parent_pid = Process.pid

      child_pid = Tlopo::Retry.retry(fork: true) { Process.pid }
      assert_kind_of(Integer, child_pid)
      refute_equal(parent_pid, child_pid)
    end

    def test_that_it_raises_unknown_opts
      e = assert_raises RuntimeError do
        Tlopo::Retry.retry(unknown: 1) { nil }
      end
      assert_match('unknown', e.message)
    end

    def test_that_it_calls_cleanup
      desired = 1
      received = nil
      begin
        received = Tlopo::Retry.retry(
          tries: 1,
          cleanup: proc { received = desired }
        ) { raise 'whatever' }
      rescue RuntimeError => e
        p(e.message)
      end
      assert_equal(desired, received)
    end
  end
end
