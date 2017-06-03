class Admin::SongsController < Admin::AdminController
  before_action :require_curator
  before_action :find_curator

  def index
    @search = params[:q]
    @songs = @curator.songs

    @type = params[:type]
    case @type
    when 'queued'
      @songs = @songs.queued
    when 'sent'
      @songs = @songs.sent
    else
      @type = nil
    end

    @songs = @songs.search(@search) unless @search.blank?
    @songs = @songs.positioned.page(params[:page]).per(5)
  end

  def new
    @song = @curator.songs.build
  end

  def create
    @song = @curator.songs.build(song_params)

    if params[:fetch]
      OpenGraphService.perform(@song)

      render "form"
      return
    end

    if params[:commit] and @song.save
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

  def reposition
    song = find_curator.songs.find(params[:id])
    position = case params[:position].downcase
    when 'next'
      find_curator.songs.queued.minimum(:position)
    when 'earlier'
      song.position - 1
    when 'later'
      song.position + 1
    when 'last'
      find_curator.songs.queued.maximum(:position)
    else
      redirect_to action: :index, curator_id: find_curator.id and return
    end
    song.reposition!(position)
    redirect_to action: :index, curator_id: find_curator.id
  end

  private

  def find_curator
    return @curator if @curator
    if current_user.admin?
      @curator = Curator.find(params[:curator_id])
    else
      @curator = current_user.curators.find(params[:curator_id])
    end
  end

  def song_params
    params.require(:song).permit(:url, :title, :description, :image_url, genre_ids: [])
  end
end
