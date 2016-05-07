class CreateAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :access_tokens do |t|
      t.references :user, foreign_key: { on_delete: :cascade }
      t.string :token, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
