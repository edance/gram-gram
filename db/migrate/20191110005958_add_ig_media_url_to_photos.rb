class AddIgMediaUrlToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :ig_media_url, :string
  end
end
