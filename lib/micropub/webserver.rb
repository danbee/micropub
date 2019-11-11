require 'sinatra'
require 'sinatra/contrib'

module Micropub
  class Webserver < Sinatra::Base
    register Sinatra::ConfigFile
    register Sinatra::Namespace

    set server: 'puma'

    github = Github.new

    endpoints = Indieauth::Endpoints.new(ENV["SITE_URL"])
    token = Indieauth::Token.new(endpoints.token_endpoint)

    get '/' do
      "Hello, World!"
    end

    get "/micropub" do
      json data: {
        posts: github.posts
      }
    end

    post "/micropub" do
      if token.validate(ENV["INDIEAUTH_TOKEN"])
        post = Post.new(params)

        if github.post!(post)
          status 201
        else
          status 400
        end
      else
        status 401
      end
    end
  end
end
