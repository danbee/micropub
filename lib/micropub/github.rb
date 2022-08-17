require "github_api"

module Micropub
  class Github
    TOKEN = ENV["GITHUB_TOKEN"]
    USER = ENV["GITHUB_USER"]
    REPO = ENV["GITHUB_REPO"]

    CONTENT_PATH = "/content/blog"

    def initialize
      @github = ::Github.new(oauth_token: TOKEN)
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
        message: "Posting: #{post.truncated_content}",
        content: post.post_content,
        branch: ENV.fetch("GITHUB_BRANCH", "main"),
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
