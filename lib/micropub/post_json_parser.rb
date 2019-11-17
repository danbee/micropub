module Micropub
  class PostJSONParser
    def initialize(json)
      @data = JSON.parse(json)
    end

    def params
      {
        "title" => title,
        "content" => content,
        "category" => category,
      }.compact
    end

    private

    attr_accessor :data

    def title
      data.dig("properties", "title", 0)
    end

    def content
      data.dig("properties", "content", 0)
    end

    def category
      data.dig("properties", "category")
    end
  end
end
