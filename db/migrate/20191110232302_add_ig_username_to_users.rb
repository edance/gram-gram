class AddIgUsernameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ig_username, :string
  end
end
