class CreateRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :recipients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :lob_address_id
      t.string :name
      t.string :address_line1
      t.string :address_line2
      t.string :address_city
      t.string :address_state
      t.string :address_zip

      t.timestamps
    end
  end
end
