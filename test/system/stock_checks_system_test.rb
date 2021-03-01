require "application_system_test_case"

class StockChecksSystemTest < ApplicationSystemTestCase
  include TestHelpers::Fakes::Finnhub::Setup

  def setup
    setup_fake_finnhub_api
    finnhub_create(:quote, stock_symbol: "SRNT", open_price: 42.42)
  end

  def test_it_works
    sign_in_as users(:mal)

    fill_in "stock_symbol", with: "SRNT"
    click_on "Check"

    assert page.has_content?("$42.42")
    assert_equal stock_check_path(:SRNT), current_path
  end
end
