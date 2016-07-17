class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :masquerade_user, :session_user

  private

  def current_user
    @current_user ||= (masquerade_user || session_user)
  end

  def masquerade_user
    masquerade = session[:masquerade_user_id]
    @masquerade_user ||= User.find(masquerade) if session_user.try(:admin?) && masquerade
  rescue ActiveRecord::RecordNotFound
    session.delete(:masquerade_user_id)
  end

  def session_user
    @session_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    reset_session
  end

  def require_login
    redirect_to new_session_url unless current_user
  end

  def require_admin
    redirect_to new_session_url and return unless current_user
    redirect_to admin_profile_url, alert: "Permission denied" unless current_user.admin?
  end

  def require_curator
    redirect_to new_session_url and return unless current_user
    redirect_to admin_profile_url, alert: "Permission denied" unless current_user.curator?
  end

  def require_no_login
    redirect_to signup_welcome_url if current_user
  end
end
