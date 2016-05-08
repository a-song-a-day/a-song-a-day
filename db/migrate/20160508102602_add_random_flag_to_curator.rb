class AddRandomFlagToCurator < ActiveRecord::Migration[5.0]
  def change
    add_column :curators, :random, :boolean, default: false, null: false
    add_index :curators, :random, unique: true, where: 'random = true'
  end
end
