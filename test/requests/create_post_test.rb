require "request_helper"
require "micropub/indieauth"
require "micropub/github"

describe "create post" do
  it "creates a simple post" do
    Micropub::Webserver.any_instance.stubs(:valid_token?).returns(true)
    Micropub::Github.any_instance.stubs(:post!).returns(true)

    post '/micropub/main', {
      content: "Hello, World!"
    }

    date = Time.now.strftime("%Y/%m/%d")
    assert last_response.accepted?
    assert_equal last_response.headers["Location"],
      "https://test.danbarber.me/blog/#{date}/hello-world"
  end
end
