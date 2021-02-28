module CookieAuthentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?
  end

  def current_user
    @current_user ||= user_from_session
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    @current_user = nil
  end

  def require_user
    unless current_user
      store_location
      flash[:warning] = 'You must be signed in to access this page'
      redirect_to new_session_path
    end
  end

  def require_no_user
    if current_user
      flash[:warning] = 'You must be signed out to access this page'
      redirect_to root_path
    end
  end

  def redirect_to_stored_or(default)
    redirect_to(session[:stored_location] || default)
    session.delete(:stored_location)
  end

  def store_location
    session[:stored_location] = request.original_url if request.get?
  end

  private

    def user_from_session
      session[:user_id] && User.find_by(id: session[:user_id])
    end
end
