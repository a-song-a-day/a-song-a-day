class Signup::GenresController < ApplicationController
  before_action :require_login

  def new
    if current_user.subscriptions.any?
      redirect_to admin_subscriptions_path
      return
    end

    @genres = Genre.where(id: Curator.all.pluck(:genre_id).uniq).order(:name)

    render :form
  end
end
