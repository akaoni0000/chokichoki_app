class Change113 < ActiveRecord::Migration[5.2]
  def change
    remove_column :cancel_reservations, :notification_status, :integer
    add_column :cancel_reservations, :notification_status, :boolean, default: false
    remove_column :reservations, :cancel_status, :boolean
  end
end
