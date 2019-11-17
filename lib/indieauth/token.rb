module Indieauth
  class Token
    def initialize(endpoint)
      @endpoint = endpoint
    end

    def validate(token)
      response = Faraday.get(
        endpoint,
        nil,
        "Accept" => "application/json",
        "Authorization" => "Bearer #{token}"
      )

      if response.status == 200
        return true
      end

      false
    end

    private

    attr_accessor :endpoint
  end
end
