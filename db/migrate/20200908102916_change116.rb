class Change116 < ActiveRecord::Migration[5.2]
  def change
    remove_column :cancel_reservations, :room_id, :integer
  end
end
