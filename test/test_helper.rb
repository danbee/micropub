$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "micropub"

require "rack/test"
require "minitest/autorun"
require "mocha/minitest"

require "pry"
