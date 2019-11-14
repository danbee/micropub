require "minitest/autorun"
require_relative "../../../../lib/micropub/models/post"

describe Post do
  describe "#id" do
    it "parameterizes the title" do
      post = Post.new("title" => "My amazing post")

      _(post.id).must_equal "my-amazing-post"
    end

    it "parameterizes the post content if there's no title" do
      post = Post.new("content" => "Hello, World!")

      _(post.id).must_equal "hello-world"
    end

    it "parameterizes the truncated post content" do
      post = Post.new(
        "content" => <<~CONTENT
          Your bones don't break, mine do. That's clear. Your cells react to
          bacteria and viruses differently than mine. You don't get sick, I do.
          That's also clear. But for some reason, you and I react the exact
          same way to water. We swallow it too fast, we choke. We get some in
          our lungs, we drown. However unreal it may seem, we are connected,
          you and I. We're on the same curve, just on opposite ends.
        CONTENT
      )

      _(post.id).must_equal "your-bones-don-t-break-mine-do"
    end
  end

  describe "#title" do
    it "returns the title" do
      post = Post.new("title" => "My great post")

      _(post.title).must_equal "My great post"
    end

    it "returns the content if there's no title" do
      post = Post.new("content" => "My money's in that office, right?")

      _(post.title).must_equal "My money's in that office, right?"
    end
  end

  describe "#path" do
    it "returns the new path of the post" do
      post = Post.new(
        "published" => "2019/02/09",
        "content" => "My great post.",
      )

      _(post.path).must_equal "/blog/2019/02/09/my-great-post"
    end
  end

  describe "#truncated_content" do
    it "returns the content if it's six words or less" do
      post = Post.new("content" => "My money's in that office, right?")

      _(post.truncated_content).must_equal "My money's in that office, right?"
    end

    it "truncates the content to six words" do
      post = Post.new(
        "content" => <<~CONTENT
          Your bones don't break, mine do. That's clear. Your cells react to
          bacteria and viruses differently than mine. You don't get sick, I do.
          That's also clear. But for some reason, you and I react the exact
          same way to water. We swallow it too fast, we choke. We get some in
          our lungs, we drown. However unreal it may seem, we are connected,
          you and I. We're on the same curve, just on opposite ends.
        CONTENT
      )

      _(post.truncated_content).must_equal "Your bones don't break, mine do."
    end

    it "adds an ellipsis if the content is truncated in a sentence" do
      post = Post.new(
        "content" => "The path of the righteous man is beset on all sides by "\
                     "the iniquities of the selfish and the tyranny of evil "\
                     "men.",
      )

      _(post.truncated_content).must_equal "The path of the righteous man…"
    end
  end

  describe "#published" do
    it "returns the parsed date" do
      post = Post.new("published" => "2019-11-01")

      _(post.published).must_equal DateTime.new(2019, 11, 1)
    end

    it "returns todays date if no date is passed" do
      post = Post.new

      _(post.published.to_s).must_equal DateTime.now.to_s
    end
  end

  describe "#categories" do
    it "returns the list of categories" do
      post = Post.new("category" => ["shows", "pilot"])

      _(post.categories).must_equal ["shows", "pilot"]
    end

    it "returns an empty array if there are no categories" do
      post = Post.new

      _(post.categories).must_equal []
    end

    it "returns an array with a single category" do
      post = Post.new("category" => "fried-chicken")

      _(post.categories).must_equal ["fried-chicken"]
    end
  end

  describe "#content" do
    it "returns the content" do
      post = Post.new("content" => "Hello, World!")

      _(post.content).must_equal "Hello, World!"
    end
  end

  describe "#post_content" do
    it "returns a post formatted for hugo" do
      post = Post.new(
        "content" => "Hallo, Earth!",
        "published" => "2019-11-12",
        "category" => ["one", "two", "three"],
      )

      _(post.post_content).must_equal <<~POST
        ---
        date: '2019-11-12T00:00:00+00:00'
        layout: micropost
        categories:
        - one
        - two
        - three
        ---

        Hallo, Earth!
      POST
    end
  end
end
