class Change111 < ActiveRecord::Migration[5.2]
  def change
    remove_column :reservations, :notification_status, :integer
    add_column :reservations, :notification_status, :boolean, default: false
    remove_column :reservations, :cancel_status, :integer
    add_column :reservations, :cancel_status, :boolean, default: false
  end
end
