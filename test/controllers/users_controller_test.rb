require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def test_can_not_create_a_new_user_while_signed_in
    sign_in_as users(:mal)

    get new_user_path
    flash[:warning] = 'You must be signed out to access this page'
    assert_response :redirect

    post users_path, params: { user: {} }
    flash[:warning] = 'You must be signed out to access this page'
    assert_response :redirect
  end

  def test_creating_a_new_user_also_creates_new_session
    assert_difference "User.count", +1 do
      post users_path, params: {
                                user: {
                                  username: "wash",
                                  password: "password",
                                  password_confirmation: "password"
                                }
                              }
    end

    assert signed_in?
    assert_equal "Welcome! 👋", flash[:success]

    follow_redirect!
    assert_equal "/", request.path
    assert flash.rendered.include?("Welcome! 👋")
  end

  def test_can_not_create_user_with_existing_username_case_insensitive
    assert_not_equal users(:mal).username, users(:mal).username.upcase # sanity check

    post users_path, params: {
                               user: {
                                 username: users(:mal).username.upcase,
                                 password: "password",
                                 password_confirmation: "password"
                               }
                             }
    assert form_errors.include?("Username has already been taken")
  end

  private

    def signed_in?
      !session[:user_id].nil?
    end

    def form_errors
      css_select('form div[role="alert"] li').collect(&:text)
    end
end
