class AddDeliveryDateToPostcardReceipts < ActiveRecord::Migration[6.0]
  def change
    add_column :postcard_receipts, :expected_delivery_date, :date
  end
end
