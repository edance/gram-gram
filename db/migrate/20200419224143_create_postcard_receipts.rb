class CreatePostcardReceipts < ActiveRecord::Migration[6.0]
  def change
    create_table :postcard_receipts, id: :uuid do |t|
      t.string :lob_id
      t.integer "status", default: 0, null: false

      # Add address for where it was sent
      t.string :address_name
      t.string :address_line1
      t.string :address_line2
      t.string :address_city
      t.string :address_state
      t.string :address_zip

      t.references :recipient, null: false, foreign_key: true, type: :uuid
      t.references :order, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
