require "github_api"

module Micropub
  class Github
    API_TOKEN = ENV["GITHUB_API_TOKEN"]
    USER = ENV["GITHUB_USER"]
    REPO = ENV["GITHUB_REPO"]

    CONTENT_PATH = "/content/blog"

    def initialize
      @github = ::Github.new(oauth_token: API_TOKEN)
    end

    def post!(post)
      path = "content/blog/"\
             "#{post.published.strftime("%Y-%m-%d")}-#{post.id}/"\
             "index.md"

      github.repos.contents.create(
        "danbee",
        "danbarber.me.hugo",
        path,
        path: path,
        message: "Posting a post",
        content: post.post_content,
        branch: ENV.fetch("GITHUB_BRANCH", "master"),
      )
    end

    def posts
      @_posts ||=
        github.repos.contents.get(USER, REPO, CONTENT_PATH).
        map(&:name)
    end

    private

    attr_accessor :github
  end
end
