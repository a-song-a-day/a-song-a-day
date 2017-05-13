class AddUserBounced < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :bounced, :boolean, default: false
  end
end
