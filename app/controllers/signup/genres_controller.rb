class Signup::GenresController < ApplicationController
  before_action :require_login

  def new
    render :form
  end

  def create
    render :form
  end
end
