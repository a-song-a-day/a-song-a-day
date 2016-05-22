class SessionsController < ApplicationController
  before_action :require_no_login, except: :destroy

  def new
  end

  def create
    @email = params[:email]

    user = User.where(email: params[:email]).first

    unless user.nil?
      token = user.access_tokens.create!

      TransactionalMailer.login(user, token).deliver
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
