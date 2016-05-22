class AddConfirmedEmailToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :confirmed_email, :boolean, null: false, default: false
  end
end
