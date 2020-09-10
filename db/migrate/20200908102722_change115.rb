class Change115 < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :reservation_token, :string
    add_column :cancel_reservations, :reservation_token, :string
  end
end
