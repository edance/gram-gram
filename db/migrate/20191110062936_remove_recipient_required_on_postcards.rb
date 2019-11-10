class RemoveRecipientRequiredOnPostcards < ActiveRecord::Migration[6.0]
  def change
    change_column :postcards, :recipient_id, :integer, null: true
  end
end
