class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: { on_delete: :cascade }
      t.references :curator, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
