class Change123y18 < ActiveRecord::Migration[5.2]
  def change
    remove_column :hairdressers, :images, :string
    add_column :hairdressers, :style_images, :string
  end
end
