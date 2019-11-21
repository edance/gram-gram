class AddAssociationIndexes < ActiveRecord::Migration[6.0]
  def up
    add_index :photos, :user_id

    add_index :postcards, :photo_id
    add_index :postcards, :recipient_id

    add_index :recipients, :user_id
  end
end
