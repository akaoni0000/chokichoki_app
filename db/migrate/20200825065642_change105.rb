class Change105 < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :activation_status, :boolean
    add_column :users, :activation_status, :boolean, default: false
  end
end
