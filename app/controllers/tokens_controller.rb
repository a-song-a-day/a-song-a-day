class TokensController < ApplicationController
  def show
    token = AccessToken.from_param(params[:id])
    user = token.user

    user.confirmed_email = true
    user.save!

    reset_session

    session[:user_id] = user.id
    redirect_to root_url
  end
end
