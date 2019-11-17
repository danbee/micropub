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
    data.dig("properties", "content", 0) || nested_content
  end

  def nested_content
    text = data.dig("properties", "content", "text", 0)
    html = data.dig("properties", "content", "html", 0)

    return nil if text.nil? && html.nil?

    { "text" => text, "html" => html }.compact
  end

  def category
    data.dig("properties", "category")
  end
end
