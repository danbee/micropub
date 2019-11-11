require 'sinatra'
require 'sinatra/contrib'

module Micropub
  class Webserver < Sinatra::Base
    register Sinatra::ConfigFile
    register Sinatra::Namespace

    set server: 'puma'

    github = Github.new

    get '/' do
      "Hello, World!"
    end

    get "/micropub" do
      json data: {
        posts: github.posts
      }
    end

    post "/micropub" do
      # verify_token

      post = Post.new(params)

      if github.post!(post)
        status 201
      else
        status 400
      end
    end
  end
end
