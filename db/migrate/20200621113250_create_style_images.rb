class CreateStyleImages < ActiveRecord::Migration[5.2]
  def change
    create_table :style_images do |t|
      
      t.integer :hairdresser_id
      t.string :style_image_id
      t.timestamps
    end
  end
end
