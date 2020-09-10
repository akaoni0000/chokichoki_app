class Change110 < ActiveRecord::Migration[5.2]
  def change
    remove_column :menus, :status, :integer
    add_column :menus, :status, :boolean, default: false
  end
end
