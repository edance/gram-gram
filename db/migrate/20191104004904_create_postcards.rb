class CreatePostcards < ActiveRecord::Migration[6.0]
  def change
    create_table :postcards do |t|
      t.references :recipient, null: false, foreign_key: true
      t.references :photo, null: false, foreign_key: true
      t.integer :status
      t.date :delivery_date
      t.string :lob_id
      t.text :caption

      t.timestamps
    end
  end
end
