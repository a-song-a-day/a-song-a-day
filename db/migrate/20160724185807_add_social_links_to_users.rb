class AddSocialLinksToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :twitter_url, :string
    add_column :users, :instagram_url, :string
    add_column :users, :spotify_url, :string
    add_column :users, :soundcloud_url, :string
  end
end
