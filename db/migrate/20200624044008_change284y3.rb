class Change284y3 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdressers, :cancel_status, :integer, default: 0
  end
end
