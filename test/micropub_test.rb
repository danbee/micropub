require "test_helper"

class MicropubTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Micropub::VERSION
  end
end
