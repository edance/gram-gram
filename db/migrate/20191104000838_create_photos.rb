class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ig_id
      t.text :ig_permalink
      t.text :ig_caption
      t.datetime :ig_timestamp

      t.timestamps
    end
  end
end
