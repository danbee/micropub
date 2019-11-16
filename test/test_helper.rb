require 'dotenv'
Dotenv.load(".env.test")

require "micropub"

require "rack/test"
require "minitest/autorun"
require "mocha/minitest"

require "pry"
