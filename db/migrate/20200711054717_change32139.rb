class Change32139 < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :category, :string
  end
end
