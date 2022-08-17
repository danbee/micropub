require "date"
require "yaml"
require "kramdown"

module Micropub
  class Post
    attr_accessor :params

    BASE_PATH="/blog"

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
      params["name"]
    end

    def path
      "#{BASE_PATH}/#{published.strftime("%Y/%m/%d")}/#{id}"
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

    def photo
      params["photo"]
    end

    def content_from_hash
      if params["content"]["text"]
        params["content"]["text"]
      elsif params["content"]["html"]
        Kramdown::Document.
          new(params["content"]["html"], input: "html").
          to_kramdown.
          gsub("\\", "")
          # TODO: Look into possible Kramdown bug
      end
    end

    def post_frontmatter
      {
        "title" => title,
        "date" => published.rfc3339,
        "layout" => "micropost",
        "categories" => categories,
      }.compact.to_yaml
    end

    def post_content
      <<~POST
      #{post_frontmatter.strip}
      ---

      #{content.strip}
      POST
    end
  end
end
