class Change3ur1 < ActiveRecord::Migration[5.2]
  def change
    remove_column :style_images, :style_images, :string
    add_column :style_images, :images, :string
  end
end
