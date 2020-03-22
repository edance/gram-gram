class AddAddressToPostcards < ActiveRecord::Migration[6.0]
  def change
    add_column :postcards, :address_name, :string
    add_column :postcards, :address_line1, :string
    add_column :postcards, :address_line2, :string
    add_column :postcards, :address_city, :string
    add_column :postcards, :address_state, :string
    add_column :postcards, :address_zip, :string
  end
end
