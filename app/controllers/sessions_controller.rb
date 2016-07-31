class SessionsController < ApplicationController
  before_action :require_no_login, except: :destroy

  def new
    @email = params[:email]
  end

  def create
    @email = params[:email]

    if @email.blank?
      flash.now[:alert] = "Email address can't be blank"
      render "new"
      return
    end

    user = User.where(email: params[:email]).first

    unless user.nil?
      user.access_tokens.expired.destroy_all
      token = user.access_tokens.create!

      TransactionalMailer.login(user, token).deliver
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
