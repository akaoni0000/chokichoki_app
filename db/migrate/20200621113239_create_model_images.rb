class CreateModelImages < ActiveRecord::Migration[5.2]
  def change
    create_table :model_images do |t|
      
      t.integer :hairdresser_id
      t.string :model_image_id
      t.timestamps
    end
  end
end
