class Admin::GenresController < Admin::AdminController
  before_action :require_admin

  def index
    @primary_genres = Genre.primary.order(:name)
    @secondary_genres = Genre.secondary.order(:name)
  end

  def new
    @genre = Genre.new

    render "form"
  end

  def create
    @genre = Genre.new(genre_params)

    if @genre.save
      redirect_to admin_genres_path, notice: "Genre '#{@genre.name}' created"
      return
    end

    render "form"
  end

  def edit
    @genre = Genre.find(params[:id])

    render "form"
  end

  def update
    @genre = Genre.find(params[:id])

    if @genre.update(genre_params)
      redirect_to admin_genres_path, notice: "Genre '#{@genre.name}' updated"
      return
    end

    render "form"
  end

  def destroy
    @genre = Genre.find(params[:id])

    if @genre.destroy
      redirect_to admin_genres_path, notice: "Genre '#{@genre.name}' deleted"
      return
    end

    render "form"
  end

  private

  def genre_params
    params.require(:genre).permit(:name, :primary)
  end
end
