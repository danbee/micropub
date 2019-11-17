require "request_helper"

describe "auth" do
  before(:each) do
    @auth_token = "123abc"
    endpoints = mock("Indieauth::Endpoints")
    endpoints.stubs(:token_endpoint)
    Indieauth::Endpoints.stubs(:new).returns endpoints
    Indieauth::Token.any_instance.stubs(:validate).returns(false)
    Indieauth::Token.any_instance.stubs(:validate).
      with(@auth_token).returns(true)
    Micropub::Github.any_instance.stubs(:post!).returns(true)
  end

  it "rejects authentication without a token" do
    post "/micropub/main", {
      content: "Hello, World!"
    }

    assert last_response.unauthorized?
  end

  it "authenticates with a header" do
    header "Authorization", "Bearer #{@auth_token}"
    post "/micropub/main", {
      content: "Hello, World!"
    }

    assert last_response.accepted?
  end

  it "authenticates with a form param" do
    post "/micropub/main", {
      access_token: @auth_token,
      content: "Hello, World!"
    }

    assert last_response.accepted?
  end
end
