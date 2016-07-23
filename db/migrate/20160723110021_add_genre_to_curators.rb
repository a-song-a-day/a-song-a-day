class AddGenreToCurators < ActiveRecord::Migration[5.0]
  def change
    add_reference :curators, :genre, foreign_key: true
  end
end
