module Finnhub
  class Quote < Base
    def self.find_by(stock_symbol:)
      response = get("/quote", params: { symbol: stock_symbol }).parse

      return nil if response.values.all?(&:zero?)
      return new(response)
    end

    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def open_price; response["o"]; end
  end
end
