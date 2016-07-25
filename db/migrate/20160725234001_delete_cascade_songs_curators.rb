class DeleteCascadeSongsCurators < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key "songs", "curators"
    add_foreign_key "songs", "curators", on_delete: :cascade
  end
end
