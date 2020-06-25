class Change323 < ActiveRecord::Migration[5.2]
  def change
    add_column :model_images, :user_id, :integer
  end
end
