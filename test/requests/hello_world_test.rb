require "test_helper"

class HelloWorldTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Micropub::Webserver
  end

  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal "Hello, World!", last_response.body
  end
end
