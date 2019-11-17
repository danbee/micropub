module Micropub
  class PostJSONParser
    def initialize(json)
      @data = JSON.parse(json)
    end

    def params
      {
        "name" => name,
        "content" => content,
        "category" => category,
      }.compact
    end

    private

    attr_accessor :data

    def name
      data.dig("properties", "name", 0)
    end

    def content
      data.dig("properties", "content", 0)
    end

    def category
      data.dig("properties", "category")
    end
  end
end
