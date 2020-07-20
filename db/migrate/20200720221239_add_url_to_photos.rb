class AddUrlToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :url, :string
  end
end
