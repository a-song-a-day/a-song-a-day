class AddUniqueSubscriptionIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :subscriptions, [:curator_id, :user_id], unique: true
  end
end
