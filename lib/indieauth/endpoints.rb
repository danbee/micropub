module Indieauth
  class Endpoints
    def initialize(site_url)
      @site_url = site_url
    end

    def endpoints
      client.endpoints
    end

    def method_missing(method)
      endpoints.send(method)
    end

    private

    def client
      IndieWeb::Endpoints::Client.new(site_url)
    end

    attr_accessor :site_url
  end
end
