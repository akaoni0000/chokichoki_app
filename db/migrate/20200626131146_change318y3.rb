class Change318y3 < ActiveRecord::Migration[5.2]
  def up
    drop_table :model_images
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
