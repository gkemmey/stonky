require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def sign_in_as(user, password: 'password')
    visit new_session_path
    fill_in "session_username", with: user.username
    fill_in "session_password", with: password

    click_button "Sign in"

    assert page.has_content?("Stock check"), "Expected to get past sign in and be at stock check page"
  end
end
