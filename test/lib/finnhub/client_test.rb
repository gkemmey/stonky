require "test_helper"

class Finnhub::ClientTest < ActiveSupport::TestCase
  include TestHelpers::Fakes::Finnhub::Setup

  setup { setup_fake_finnhub_api }

  def test_raises_generic_request_error_for_any_non_200_response
    http_client_stub = Object.new.tap { |o|
      class << o
        def get(*args, **kwargs, &block)
          OpenStruct.new(response: 500)
        end
      end
    }

    HTTP.stub(:headers, http_client_stub) do
      assert_raises(Finnhub::RequestError) do
        Finnhub::Client.new.get("/quote", params: { symbol: "SRNT" })
      end
    end
  end
end
