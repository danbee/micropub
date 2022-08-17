require "test_helper"

require "micropub/github"

describe Micropub::Github do
  describe "#post!" do
    it "sends the post to github" do
      contents = mock("contents")
      contents.expects(:create).with(
        "danbee",
        "danbarber.me.hugo",
        "content/blog/2020-01-01-hello-world/index.md",
        {
          path: "content/blog/2020-01-01-hello-world/index.md",
          message: "Posting: Hello, World!",
          :content => <<~CONTENT,
            ---
            date: '2020-01-01T00:00:00+00:00'
            layout: micropost
            categories:
            - my-blog
            ---

            Hello, World!
          CONTENT
          :branch => "main",
        }).returns(true)
      repos = mock("repos")
      repos.stubs(:contents).returns(contents)
      github_api = mock("Github")
      github_api.stubs(:repos).returns(repos)
      ::Github.stubs(:new).returns(github_api)

      github = Micropub::Github.new
      post = Micropub::Post.new(params)

      github.post!(post)
    end

    def params
      {
        "content" => "Hello, World!",
        "category" => "my-blog",
        "published" => DateTime.parse("2020-01-01").rfc3339,
      }
    end
  end
end
