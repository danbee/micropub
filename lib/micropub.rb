module Micropub
  autoload :Webserver, File.expand_path('micropub/webserver.rb', __dir__)
  autoload :Github, File.expand_path('micropub/github.rb', __dir__)
  autoload :Indieauth, File.expand_path('micropub/indieauth.rb', __dir__)
  autoload :Post, File.expand_path('micropub/models/post.rb', __dir__)
end
