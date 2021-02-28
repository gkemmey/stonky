require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  def test_can_sign_in
    post sessions_path, params: { session: { username: users(:mal).username, password: "password" } }

    assert signed_in?
    assert_redirected_to root_path
  end

  def test_sign_in_should_fail_with_invalid_credentials
    post sessions_path, params: { session: { username: "", password: "" } }
    assert_not signed_in?
    assert form_errors.include?("Invalid username and password")
  end


  def test_should_be_able_to_sign_out_twice_without_breaking_anything # sanity check
    sign_in_as users(:mal)
    assert signed_in?

    delete session_path
    assert_not signed_in?
    assert_redirected_to new_session_path

    # simulate a user clicking logout in a second window, verify nothing breaks
    delete session_path
    assert_redirected_to new_session_path
  end

  def test_can_not_login_twice
    sign_in_as users(:mal)

    get new_session_path
    assert_redirected_to root_path

    post sessions_path, params: { session: {} }
    assert_redirected_to root_path

    follow_redirect!
    assert flash.rendered.include?("You must be signed out to access this page")
  end

  # TODO - test_stores_location_and_redirects_back_after_logging_in
  #      - need more than just root path

  private

    def signed_in?
      !session[:user_id].nil?
    end

    def form_errors
      css_select('form div[role="alert"] li').collect(&:text)
    end
end
