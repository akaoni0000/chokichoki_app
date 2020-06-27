class Change313131423 < ActiveRecord::Migration[5.2]
  def up
    drop_table :style_images
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
 
end
