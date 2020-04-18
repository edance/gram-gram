class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.text :caption
      t.integer :status, default: 0, null: false
      t.string :stripe_charge_id

      t.references :photo, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
