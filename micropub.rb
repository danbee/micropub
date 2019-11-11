require "sinatra"
require "sinatra/json"

require "./lib/post"

post "/micropub" do
  verify_token

  post = Post.new(params)

  if post.save!
    status 201
  else
    status 400
  end
end

def verify_token
  # verify token
end
