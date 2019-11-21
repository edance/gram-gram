class AddUuidsToAllTables < ActiveRecord::Migration[6.0]
  def up
    tables = %w[
      photos
      postcards
      recipients
      users
    ]

    tables.each do |table|
      add_column table, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    end
  end
end
