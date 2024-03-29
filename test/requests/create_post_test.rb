require "request_helper"
require "indieauth"
require "micropub/github"

describe "create post" do
  before(:each) do
    Micropub::Webserver.any_instance.stubs(:valid_token?).returns(true)
    Micropub::Github.any_instance.stubs(:post!).returns(true)
  end

  it "creates a simple post" do
    post "/micropub", {
      content: "Hello, World!"
    }

    date = Time.now.strftime("%Y/%m/%d")
    assert last_response.accepted?
    assert_equal last_response.headers["Location"],
      "https://test.danbarber.me/blog/#{date}/hello-world"
  end

  it "creates a post with a title" do
    post "/micropub", {
      name: "My money's in that office, right?",
      content: <<~CONTENT,
        If she start giving me some bullshit about it ain"t there, and we got
        to go someplace else and get it, I"m gonna shoot you in the head then
        and there. Then I"m gonna shoot that bitch in the kneecaps, find out
        where my goddamn money is.
      CONTENT
    }

    date = Time.now.strftime("%Y/%m/%d")
    assert last_response.accepted?
    assert_equal last_response.headers["Location"],
      "https://test.danbarber.me/blog/#{date}/my-money-s-in-that-office-right"
  end

  it "creates a post with a single category" do
    post "/micropub", {
      content: "Hello, World!",
      category: "my-blog",
    }

    date = Time.now.strftime("%Y/%m/%d")
    assert last_response.accepted?
    assert_equal last_response.headers["Location"],
      "https://test.danbarber.me/blog/#{date}/hello-world"
  end

  it "creates a post with multiple categories" do
    post "/micropub", {
      content: "Hello, World!",
      category: ["one", "two", "three"],
    }

    date = Time.now.strftime("%Y/%m/%d")
    assert last_response.accepted?
    assert_equal last_response.headers["Location"],
      "https://test.danbarber.me/blog/#{date}/hello-world"
  end

  it "creates a post with JSON" do
    post_json = {
      type: ["h-entry"],
      properties: {
        content: ["Hello, World!"],
        category: ["one", "two", "three"],
      },
    }.to_json

    post "/micropub", post_json, { "CONTENT_TYPE" => "application/json" }

    date = Time.now.strftime("%Y/%m/%d")
    assert last_response.accepted?
    assert_equal last_response.headers["Location"],
      "https://test.danbarber.me/blog/#{date}/hello-world"
  end

  it "creates a post with JSON and HTML content" do
    post_json = {
      type: ["h-entry"],
      properties: {
        content: [{ html: "<p>Hello, World!</p>" }],
        category: ["one", "two", "three"],
      },
    }.to_json

    post "/micropub", post_json, { "CONTENT_TYPE" => "application/json" }

    date = Time.now.strftime("%Y/%m/%d")
    assert last_response.accepted?
    assert_equal last_response.headers["Location"],
      "https://test.danbarber.me/blog/#{date}/hello-world"
  end
end
