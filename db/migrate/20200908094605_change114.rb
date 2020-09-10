class Change114 < ActiveRecord::Migration[5.2]
  def change
    add_column :cancel_reservations, :room_id, :integer
  end
end
