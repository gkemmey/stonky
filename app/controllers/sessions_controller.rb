class SessionsController < ApplicationController
  before_action :require_no_user, only: [:new, :create]
  before_action :require_user,    only: :destroy

  def new
  end

  def create
    user = User.find_by(username: params[:session][:username].try(:downcase))

    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to_stored_or root_path
    else
      flash[:session] = { errors: ["Invalid username and password"] }
      render :new
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to new_session_path
  end
end
