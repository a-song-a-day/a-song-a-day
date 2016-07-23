class AddSongsGenresJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :genres, :songs do |t|
      t.index :song_id
    end
    add_foreign_key :genres_songs, :songs, on_delete: :cascade
    add_foreign_key :genres_songs, :genres, on_delete: :cascade
  end
end
