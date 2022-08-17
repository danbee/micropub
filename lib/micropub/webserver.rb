require "sinatra"
require "sinatra/namespace"
require "sinatra/json"

module Micropub
  class Webserver < Sinatra::Base
    register Sinatra::Namespace

    set server: 'puma'

    github = Github.new

    get '/' do
      redirect ENV.fetch("SITE_URL")
    end

    get '/view-headers' do
      content_type :text
      json request.env
    end

    get "/micropub" do
      json data: {
        posts: github.posts,
        photos: github.photos,
      }
    end

    post "/micropub" do
      if valid_token?
        post = Post.new(post_params)

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

    def post_params
      if request.env["CONTENT_TYPE"] == "application/json"
        json_params
      else
        params
      end
    end

    def json_params
      request.body.rewind
      PostJSONParser.new(request.body.read).params
    end

    def valid_token?
      token = Indieauth::Token.new(endpoints[:token_endpoint])

      _, auth_token = request.env["HTTP_AUTHORIZATION"]&.split(" ")
      auth_token ||= params["access_token"]

      token.validate(auth_token)
    end

    def endpoints
      @_endpoints ||= Indieauth::Endpoints.new(ENV.fetch("SITE_URL"))
    end
  end
end
