class AddIndexToPhotosIgId < ActiveRecord::Migration[6.0]
  def change
    add_index :photos, :ig_id, unique: true
  end
end
