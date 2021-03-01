require "test_helper"

class StockChecksControllerTest < ActionDispatch::IntegrationTest
  include TestHelpers::Fakes::Finnhub::Setup

  setup { setup_fake_finnhub_api }

  def test_new_and_show_require_user
    get new_stock_check_path
    assert_requires_user

    get stock_check_path(:SRNT)
    assert_requires_user
  end

  def test_show_generic_try_again_error_if_unable_authenticate_to_finnhub
    setup { setup_fake_finnhub_api }
    sign_in_as users(:mal)

    Finnhub::Base.client.stub(:headers, {}) do
      get stock_check_path(:SRNT)

      assert_redirected_to new_stock_check_path
      follow_redirect!
      assert flash.rendered.include?("Something broke 😬 Feel free to try again, tho.")
    end
  end

  def test_show_generic_try_again_error_for_any_finnhub_error
    setup { setup_fake_finnhub_api }
    sign_in_as users(:mal)

    Finnhub::Base.client.stub(:headers, -> { raise Finnhub::RequestError }) do
      get stock_check_path(:SRNT)

      assert_redirected_to new_stock_check_path
      follow_redirect!
      assert flash.rendered.include?("Something broke 😬 Feel free to try again, tho.")
    end
  end

  def test_shows_stock_open_price
    setup { setup_fake_finnhub_api }
    finnhub_create(:quote, stock_symbol: "SRNT", open_price: 42.42)

    sign_in_as users(:mal)

    get stock_check_path(:SRNT)
    assert_equal "$42.42", find_open_price
  end

  private

    def find_open_price
      css_select("p").find { |n| n.text.include?("Open price:") }.
                      then { |p| css_select(p, "span") }.text
    end
end
