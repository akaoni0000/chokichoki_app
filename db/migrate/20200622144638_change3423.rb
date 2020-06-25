class Change3423 < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :status, :integer
  end
end
