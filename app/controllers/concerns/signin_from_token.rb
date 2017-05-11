module SigninFromToken
  extend ActiveSupport::Concern
  def signin_from_token
    token = AccessToken.from_param(params[:token] || params[:id])
    if token.nil?
      flash[:alert] = "Bad token, try to login again"
      return false
    end
    user = token.user

    user.confirmed_email = true
    user.save!

    return_to_url = session.delete(:return_to)
    reset_session
    session[:return_to] = return_to_url
    session[:user_id] = user.id
    return true
  end
end
