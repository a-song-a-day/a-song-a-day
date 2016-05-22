class SessionsController < ApplicationController
  before_action :require_no_login, except: :destroy

  def new
  end

  def create
    user = User.where(email: params[:email]).first

    if user.nil?
      redirect_to new_session_url, alert: 'No user found for that address.'
      return
    end

    session[:user_id] = user.id if user
    redirect_to signup_welcome_url
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
