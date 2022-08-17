require "test_helper"

class HelloWorldTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Micropub::Webserver
  end

  def test_hello_world
    get '/'
    assert last_response.redirect?
  end
end
