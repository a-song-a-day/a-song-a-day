class Signup::CuratorsController < ApplicationController
  before_action :require_login

  def index
    @random = Curator.random

    @genres = Genre.where(id: params[:genre_ids])
    @curators = @genres.includes(:curators).map(&:curators).flatten.uniq - [@random]
    @curators = @curators.sort_by &:title
  end

  def create
    current_user.subscriptions.create!(subscription_params)

    if current_user.confirmed_email?
      redirect_to admin_subscriptions_url
    else
      token = current_user.access_tokens.create!
      TransactionalMailer.welcome(current_user, token).deliver
      redirect_to signup_welcome_url
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:curator_id)
  end
end
