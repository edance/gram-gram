class AddAvatarToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ig_avatar, :string
    add_column :users, :private_profile, :boolean
  end
end
