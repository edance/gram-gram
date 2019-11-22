class AddPaymentCustomerIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :payment_customer_id, :string
  end
end
