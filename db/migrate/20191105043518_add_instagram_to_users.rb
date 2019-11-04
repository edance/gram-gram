class AddInstagramToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :instagram_uid, :string
    add_column :users, :instagram_access_token, :string
  end
end
