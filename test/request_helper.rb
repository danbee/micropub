require "test_helper"

include Rack::Test::Methods

def app
  Micropub::Webserver
end
