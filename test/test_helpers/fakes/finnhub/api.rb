module TestHelpers
  module Fakes
    module Finnhub
      module Setup
        def setup_fake_finnhub_api
          sinatra_wrapper = TestHelpers::Fakes::Finnhub::API.new
          @fake_finnhub_api = sinatra_wrapper.instance_variable_get(:@instance)

          stub_request(:any, /finnhub.io/).to_rack(sinatra_wrapper)
        end

        def finnhub_create(*args, **kwargs)
          @fake_finnhub_api.create(*args, **kwargs)
        end
      end

      class API < Sinatra::Base
        attr_accessor :quotes

        def initialize
          super(nil) # Sinatra::Base intialize allows an optional "parent class": `initialize(app = nil)`

          @quotes = {}
        end

        def create(object, *args, **kwargs)
          case object.to_sym
            when :quote
              create_quote(*args, **kwargs)
            else
              raise "Finnhub::UnknownObjectType: #{object}"
          end
        end

        def create_quote(stock_symbol:, open_price:)
          quotes[stock_symbol] = { o: open_price, h: 0, l: 0, c: 0, pc: 0 }
        end

        # -------- routes --------

        before do
          content_type 'application/json'

          unless authenticated?
            halt 401, {}.to_json
          end
        end

        get "/api/v1/quote" do
          if (quote = @quotes[params[:symbol]])
            return quote.to_json
          else
            return { o: 0, h: 0, l: 0, c: 0, pc: 0 }.to_json
          end
        end

        private

          def authenticated?
            request.env["HTTP_X_FINNHUB_TOKEN"] == "no_key"
          end
      end
    end
  end
end
