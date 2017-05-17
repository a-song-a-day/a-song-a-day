class CreateDailyMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_messages do |t|
      t.references :creator
      t.text :message, null: false
      t.integer :receivers, default: 0
      t.date :send_at
      t.boolean :sent, default: false

      t.timestamps
    end
  end
end
