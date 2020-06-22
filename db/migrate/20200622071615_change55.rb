class Change55 < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :explanation, :text
  end
end
