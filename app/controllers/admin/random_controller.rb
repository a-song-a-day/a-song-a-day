class Admin::RandomController < Admin::AdminController
  before_action :require_admin

  def copy
    song = Song.find(params[:song_id])
    attributes = song.attributes.slice(*%w[url title image_url genre_ids])
    attributes['description'] = <<-EOF.strip_heredoc.chomp
      #{song.description}
      
      (Originally curated by #{song.curator.user.name})
    EOF

    random = Curator.random
    random.songs.create!(attributes)

    redirect_to admin_curator_path(random),
      notice: 'Copied song to random song queue'
  end
end
