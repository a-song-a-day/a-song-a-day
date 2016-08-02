class AddSentSubscriptionIdsToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :sent_subscription_ids, :integer, array: true, default: []
    add_index :songs, :sent_subscription_ids, using: 'gin'
  end
end
