class AddDefaultValueToStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :postcards, :status, :integer, default: 0, null: false
  end
end
