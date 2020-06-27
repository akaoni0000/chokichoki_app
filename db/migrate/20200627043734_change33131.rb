class Change33131 < ActiveRecord::Migration[5.2]
  def change
    remove_column :style_images, :images, :string
    add_column :style_images, :hair_images, :string
  end
end
