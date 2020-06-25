class Chga223 < ActiveRecord::Migration[5.2]
  def change
    remove_column :model_images, :hairdresser_id, :integer
   
  end
end
