require "date"
require "kramdown"

module Micropub
  class Post
    attr_accessor :params

    def initialize(params = {})
      @params = params
    end

    def id
      (title || truncated_content).
        downcase.
        gsub(/[^a-z]+/, " ").
        strip.
        gsub(" ", "-")
    end

    def title
      params["title"]
    end

    def path
      "/blog/#{published.strftime("%Y/%m/%d")}/#{id}"
    end

    def truncated_content
      content[0..content.index(".")].
        split(" ").
        take(6).
        join(" ").
        gsub(/([a-z])$/, "\\1…")
    end

    def published
      if params["published"]
        DateTime.parse(params["published"])
      else
        DateTime.now
      end
    end

    def categories
      if params["category"].is_a?(Array)
        params["category"] || []
      else
        [params["category"]].compact
      end
    end

    def content
      if params["content"].is_a?(Hash)
        content_from_hash
      else
        params["content"]
      end
    end

    def content_from_hash
      if params["content"]["text"]
        params["content"]["text"]
      elsif params["content"]["html"]
        Kramdown::Document.
          new(params["content"]["html"], html_to_native: true).
          to_kramdown
      end
    end

    def post_content
      <<~POST
      ---
      date: '#{published.rfc3339}'
      layout: micropost
      categories:
      #{categories.map { |category| "- #{category}\n" }.join.strip}
      ---

      #{content}
      POST
    end
  end
end
