require "test_helper"

class Finnhub::QuoteTest < ActiveSupport::TestCase
  include TestHelpers::Fakes::Finnhub::Setup

  setup { setup_fake_finnhub_api }

  def test_find_by_returns_object_that_knows_open_price
    finnhub_create(:quote, stock_symbol: "SRNT", open_price: 42.0)
    assert_equal 42, Finnhub::Quote.find_by(stock_symbol: :SRNT).open_price
  end

  def test_find_by_returns_nil_for_missing_stock_symbols
    assert_nil Finnhub::Quote.find_by(stock_symbol: :SRNT)

    # finnhub aggressively returns a 200 here, and treats an unkown stock symbol as all blank.
    # we'll treat that as nil to mimic find_by in active record, so test that, too.
    #
    finnhub_create(:quote, stock_symbol: "SRNT", open_price: 0)
    assert_nil Finnhub::Quote.find_by(stock_symbol: :SRNT)
  end
end
