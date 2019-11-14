class AddStripeChargeIdToPostcards < ActiveRecord::Migration[6.0]
  def change
    add_column :postcards, :stripe_charge_id, :string
  end
end
