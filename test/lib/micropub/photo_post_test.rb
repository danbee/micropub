require "test_helper"

require "micropub/photo_post"

describe Micropub::PhotoPost do
  describe "#post_content" do
    it "returns a post formatted for hugo" do
      post = Micropub::PhotoPost.new(
        "content" => "Hallo, Earth!",
        "published" => "2019-11-12",
        "category" => ["one", "two", "three"],
        "photo" => "photo.jpg",
      )

      _(post.post_content).must_equal <<~POST
        ---
        date: '2019-11-12T00:00:00+00:00'
        layout: micropost
        categories:
        - one
        - two
        - three
        image: photo.jpg
        ---

        <figure class="photo photo--wide">
          {{< img src="photo.jpg" alt="" caption="" >}}

          <figcaption></figcaption>
        </figure>

        Hallo, Earth!
      POST
    end

    it "returns a post formatted for hugo with a title" do
      post = Micropub::PhotoPost.new(
        "name" => "Welcome!",
        "content" => "Hallo, Earth!",
        "published" => "2019-11-12",
        "category" => ["one", "two", "three"],
        "photo" => "photo.jpg",
      )

      _(post.post_content).must_equal <<~POST
        ---
        title: Welcome!
        date: '2019-11-12T00:00:00+00:00'
        layout: post
        categories:
        - one
        - two
        - three
        image: photo.jpg
        ---

        <figure class="photo photo--wide">
          {{< img src="photo.jpg" alt="" caption="" >}}

          <figcaption></figcaption>
        </figure>

        Hallo, Earth!
      POST
    end
  end
end
