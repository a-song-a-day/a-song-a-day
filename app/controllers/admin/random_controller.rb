class Admin::RandomController < Admin::AdminController
  before_action :require_admin

  def copy
    song = Song.find(params[:song_id])
    song_params = %i(url title description image_url genre_ids).map do |attr|
      [attr, song.send(attr)]
    end.to_h

    random = Curator.random
    random.songs.create!(song_params)

    redirect_to admin_curator_path(random),
      notice: "Copied song to random song queue"
  end
end
