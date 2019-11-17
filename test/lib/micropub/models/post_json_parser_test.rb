require "test_helper"

require "micropub/models/post_json_parser"

describe PostJSONParser do
  describe "#params" do
    it "parses basic attributes" do
      json = <<~JS
        {
          "type": ["h-entry"],
          "properties": {
            "content": ["Hello, World!"]
          }
        }
      JS

      parser = PostJSONParser.new(json)

      _(parser.params).must_equal(
        { "content" => "Hello, World!" }
      )
    end

    it "parses content with nested text" do
      json = <<~JS
        {
          "type": ["h-entry"],
          "properties": {
            "content": {
              "text": ["Hello, World!"]
            }
          }
        }
      JS

      parser = PostJSONParser.new(json)

      _(parser.params).must_equal(
        { "content" => { "text" => "Hello, World!" } }
      )
    end

    it "parses content with nested html" do
      json = <<~JS
        {
          "type": ["h-entry"],
          "properties": {
            "content": {
              "html": ["<p>Hello, World!</p>"]
            }
          }
        }
      JS

      parser = PostJSONParser.new(json)

      _(parser.params).must_equal(
        { "content" => { "html" => "<p>Hello, World!</p>" } }
      )
    end

    it "parses a single category" do
      json = <<~JS
        {
          "type": ["h-entry"],
          "properties": {
            "category": ["test"]
          }
        }
      JS

      parser = PostJSONParser.new(json)

      _(parser.params).must_equal(
        { "category" => ["test"] }
      )
    end
  end
end
