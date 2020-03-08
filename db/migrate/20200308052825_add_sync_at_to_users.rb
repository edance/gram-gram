class AddSyncAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sync_at, :datetime
  end
end
