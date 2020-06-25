class Change13u920 < ActiveRecord::Migration[5.2]
  def change
    remove_column :hairdressers, :cancel_status, :integer, default: 0
    add_column :reservations, :cancel_status, :integer, default: 0
  end
end
