class Change118 < ActiveRecord::Migration[5.2]
  def change
    def up
      drop_table :comments
    end
    def down
      raise ActiveRecord::IrreversibleMigration
    end
  end
end
