require 'sinatra'
require 'sinatra/contrib'

module Micropub
  class Webserver < Sinatra::Base
    register Sinatra::Namespace

    set server: 'puma'

    github = Github.new

    get '/' do
      "Hello, World!"
    end

    get '/view-headers' do
      content_type :text
      json request.env
    end

    get "/micropub/main" do
      json data: {
        posts: github.posts
      }
    end

    post "/micropub/main" do
      if valid_token?
        post = Post.new(params)

        if github.post!(post)
          headers "Location" => "#{ENV.fetch("SITE_URL")}#{post.path}"
          status 202
        else
          status 400
        end
      else
        status 401
      end
    end

    def valid_token?
      token = Indieauth::Token.new(endpoints.token_endpoint)

      auth_type, auth_token = request.env["HTTP_AUTHORIZATION"]&.split(" ")

      auth_type == "Bearer" && token.validate(auth_token)
    end

    def endpoints
      @_endpoints ||= Indieauth::Endpoints.new(ENV.fetch("SITE_URL"))
    end
  end
end
