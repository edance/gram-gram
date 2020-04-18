class CreateOrdersRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :orders_recipients, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid
      t.references :recipient, null: false, foreign_key: true, type: :uuid
    end
  end
end
