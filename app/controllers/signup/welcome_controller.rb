class Signup::WelcomeController < ApplicationController
  before_action :require_login

  def index
    @curator = current_user.subscriptions.first.try(:curator)
    redirect_to admin_profile_path if current_user.confirmed_email?
  end
end
