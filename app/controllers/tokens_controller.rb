class TokensController < ApplicationController
  def show
    token = AccessToken.from_param(params[:id])
    user = token.user

    user.confirmed_email = true
    user.save!

    next_url = session.delete(:return_to) || root_url
    reset_session

    session[:user_id] = user.id
    redirect_to next_url
  end
end
