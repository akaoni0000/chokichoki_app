class Change109 < ActiveRecord::Migration[5.2]
  def change
    remove_column :reservations, :status, :integer
    add_column :reservations, :status, :boolean, default: false
  end
end
