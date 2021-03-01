module Finnhub
  class Client
    def initialize
      @api_key = Rails.application.credentials.finnhub.fetch(Rails.env.to_sym).fetch(:api_key)
    end

    def talk(path, method:, params: nil)
      response = HTTP.headers(headers).
                      send(method, build_url(path), params: params)

      if !(200..299).cover?(response.status)
        raise Finnhub::RequestError.new("not ok")
      end

      return response
    end

    def get(path, **options)
      talk(path, method: :get, **options)
    end

    private

      def build_url(path)
        URI::HTTPS.build(host: "finnhub.io", path: "/api/v1#{path}").to_s
      end

      def headers
        { "X-Finnhub-Token": @api_key }
      end
  end
end
