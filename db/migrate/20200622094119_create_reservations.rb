class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      
      t.integer :menu_id
      t.integer :user_id
      t.datetime :start_time
      t.text :user_request
      t.timestamps
    end
  end
end
