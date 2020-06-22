class Change43 < ActiveRecord::Migration[5.2]
  def change
    remove_column :menus, :user_id, :integer
    remove_column :menus, :start_time, :datetime
    remove_column :menus, :user_repuest, :text
  end
end
