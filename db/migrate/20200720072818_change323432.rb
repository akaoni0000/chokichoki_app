class Change323432 < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :notification_status, :integer, default: 0
  end
end
