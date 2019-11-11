require "indieweb/endpoints"

module Indieauth
  class Endpoints
    def initialize(site_url)
      @endpoints = IndieWeb::Endpoints.get(site_url)
    end

    def method_missing(method)
      endpoints.send(method)
    end

    private

    attr_accessor :endpoints
  end
end
