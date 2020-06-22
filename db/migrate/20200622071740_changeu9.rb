class Changeu9 < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :menu_image_id, :string
  end
end
