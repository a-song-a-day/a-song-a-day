class Signup::StartController < ApplicationController
  before_action :require_no_login

  def new
    @user = User.new(email: params[:email])
    @user.valid?(:signup_start)

    render :form
  end

  def create
    @user = User.new(user_params)

    render :form and return unless @user.save

    session[:user_id] = @user.id

    redirect_to signup_genres_url and return if params[:curator]

    @user.subscriptions.create(curator: Curator.random)
    token = @user.access_tokens.create!

    TransactionalMailer.welcome(@user, token).deliver

    redirect_to signup_welcome_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :extra_information)
  end
end
