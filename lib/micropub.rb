autoload :Indieauth, File.expand_path('indieauth.rb', __dir__)

module Micropub
  autoload :Github, File.expand_path('micropub/github.rb', __dir__)
  autoload :Post, File.expand_path('micropub/models/post.rb', __dir__)
  autoload :PostJSONParser,
    File.expand_path('micropub/models/post_json_parser.rb', __dir__)
  autoload :Webserver, File.expand_path('micropub/webserver.rb', __dir__)
end
