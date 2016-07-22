class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.references :curator, foreign_key: true
      t.string :url, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.string :image_url
      t.datetime :sent_at

      t.timestamps
    end
  end
end
