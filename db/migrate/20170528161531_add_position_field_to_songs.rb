class AddPositionFieldToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :position, :integer
    Song.all.order(:created_at).each do |song|
      song.set_position
      song.save
    end
  end
end
