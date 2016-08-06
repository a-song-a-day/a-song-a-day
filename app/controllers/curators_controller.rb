class CuratorsController < ApplicationController
  def show
    @curator = Curator.find(params[:id])
  end
end
