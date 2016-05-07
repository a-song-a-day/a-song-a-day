class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.text :extra_information
      t.boolean :curator, null: false, default: false
      t.boolean :admin, null: false, default: false

      t.timestamps
    end
  end
end
