require "test_helper"
require 'minitest/hooks'

include Rack::Test::Methods
MiniTest::Spec.register_spec_type(/something/, Minitest::HooksSpec)

def app
  Micropub::Webserver
end

ENV["SITE_URL"] = "https://test.danbarber.me"
