class RemoveIndexIgId < ActiveRecord::Migration[6.0]
  def change
    remove_index :photos, name: 'index_photos_on_ig_id'
  end
end
