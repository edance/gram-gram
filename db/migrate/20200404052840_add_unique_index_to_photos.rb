class AddUniqueIndexToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_index :photos, %i[ig_id user_id], unique: true
  end
end
