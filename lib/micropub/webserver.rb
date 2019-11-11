require 'sinatra'
require 'sinatra/contrib'

module Micropub
  class Webserver < Sinatra::Base
    register Sinatra::ConfigFile
    register Sinatra::Namespace

    set server: 'puma'

    github = Github.new

    endpoints = Indieauth::Endpoints.new(ENV.fetch("SITE_URL"))
    token = Indieauth::Token.new(endpoints.token_endpoint)

    get '/' do
      "Hello, World!"
    end

    get "/micropub/main" do
      json data: {
        posts: github.posts
      }
    end

    post "/micropub/main" do
      if token.validate(ENV.fetch("INDIEAUTH_TOKEN"))
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
