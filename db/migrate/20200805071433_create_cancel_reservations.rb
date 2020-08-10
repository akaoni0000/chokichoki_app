class CreateCancelReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :cancel_reservations do |t|

      t.integer :menu_id
      t.integer :user_id
      t.datetime :start_time
      t.integer :hairdresser_id
      t.integer :notification_status, default: 0
      t.timestamps
    end
  end
end
