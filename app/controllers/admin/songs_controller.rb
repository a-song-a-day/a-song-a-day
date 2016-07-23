class Admin::SongsController < Admin::AdminController
  before_action :require_curator
  before_action :find_curator

  def index
    @search = params[:q]
    @songs = @curator.songs
    @songs = @songs.search(@search) unless @search.blank?
    @songs = @songs.order(created_at: :desc).page(params[:page]).per(5)
  end

  def new
    @song = @curator.songs.build
  end

  def create
    @song = @curator.songs.build(song_params)

    if params[:oembed]
      begin
        result = OEmbed::Providers.get(@song.url)

        @song.attributes = {
          title: result.title,
          image_url: result.thumbnail_url
        } unless result.nil?
      rescue OEmbed::NotFound => e
        Rails.logger.debug e
      end

      render "form"
      return
    end

    if params[:commit] and @curator.save
      redirect_to admin_curator_songs_path(@curator)
      return
    end

    render "form"
  end

  def show
    @song = @curator.songs.find(params[:id])
  end

  def edit
    @song = @curator.songs.find(params[:id])

    render "form"
  end

  def update
    @song = @curator.songs.find(params[:id])
    @song.attributes = song_params

    if params[:commit] and @song.save
      redirect_to admin_curator_songs_path(@curator), notice: "Song updated"
      return
    end

    render "form"
  end

  def destroy
    @song = @curator.songs.find(params[:id])

    if @song.destroy
      redirect_to admin_curator_songs_path(@curator), notice: "Song '#{@song.title}' deleted"
    else
      redirect_to admin_curator_songs_path(@curator), error: "Failed to delete song '#{@song.title}'"
    end
  end

  private

  def find_curator
    @curator = current_user.curators.find(params[:curator_id])
  end

  def song_params
    params.require(:song).permit(:url, :title, :description, :image_url, genre_ids: [])
  end
end
