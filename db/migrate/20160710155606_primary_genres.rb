class PrimaryGenres < ActiveRecord::Migration[5.0]
  def change
    add_column :genres, :primary, :boolean, default: false
  end
end
