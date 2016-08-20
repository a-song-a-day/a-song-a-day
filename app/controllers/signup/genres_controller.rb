class Signup::GenresController < ApplicationController
  before_action :require_login

  def new
    @genres = Genre.where(id: Curator.all.pluck(:genre_id).uniq).order(:name)

    render :form
  end
end
