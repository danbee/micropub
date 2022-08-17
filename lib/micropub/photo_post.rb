module Micropub
  class PhotoPost < Post
    BASE_PATH="/photos"

    def alt_text
      params["alt_text"]
    end

    def caption
      params["caption"]
    end

    def post_content
      <<~POST
      #{post_frontmatter.strip}
      ---

      <figure class="photo photo--wide">
        {{< img src="#{photo}" alt="#{alt_text}" caption="#{caption}" >}}

        <figcaption>#{caption}</figcaption>
      </figure>

      #{content.strip}
      POST
    end
  end
end
