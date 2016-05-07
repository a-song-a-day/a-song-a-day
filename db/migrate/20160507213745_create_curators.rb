class CreateCurators < ActiveRecord::Migration[5.0]
  def change
    create_table :curators do |t|
      t.references :user, foreign_key: { on_delete: :cascade }
      t.string :title, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
