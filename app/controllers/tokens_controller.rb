class TokensController < ApplicationController
  include SigninFromToken
  def show
    if signin_from_token
      next_url = session.delete(:return_to) || admin_profile_path
      redirect_to next_url and return
    end
    redirect_to new_session_url
  end
end
