class AddCuratorGenresJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :curators, :genres do |t|
      t.index :curator_id
    end
    add_foreign_key :curators_genres, :curators, on_delete: :cascade
    add_foreign_key :curators_genres, :genres, on_delete: :cascade
  end
end
