require 'test_helper'

# ensure that it retries block
# ensure it times out
# ensure it forks
# ensure it raises unknown option


class Tlopo::RetryTest < Minitest::Test
  def setup
    @opts = {
      timeout: 10,
      desc: 'unit testing'
    }
  end


  def test_that_it_has_a_version_number
    refute_nil ::Tlopo::Retry::VERSION
  end

  def test_that_it_times_out
     e = assert_raises Timeout::Error do
       Tlopo::Retry.retry(timeout: 1) { sleep 2 }
     end
     File.open('/tmp/1','w+'){|f| f.puts [e, e.class, e.message]}
     assert_equal 'execution expired', e.message
  end
end
