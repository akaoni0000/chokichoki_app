class Change119 < ActiveRecord::Migration[5.2]
  def change
    remove_column :menus, :sex_status, :integer
  end
end
