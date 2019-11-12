class Post
  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def id
    title.
      downcase.
      gsub(/[^a-z]+/, " ").
      strip.
      gsub(" ", "-")
  end

  def title
    params["title"] || truncated_content
  end

  def truncated_content
    content[0..content.index(".")].
      split(" ").
      take(6).
      join(" ").
      gsub(/([a-z])$/, "\1…")
  end

  def published
    if params["published"]
      DateTime.parse(params["published"])
    else
      DateTime.now
    end
  end

  def categories
    params["category"] || []
  end

  def content
    params["content"]
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
