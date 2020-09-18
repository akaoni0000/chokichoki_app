class Change117 < ActiveRecord::Migration[5.2]
  def change
      def up
        drop_table :comments
      end
    
      def down
        fail ActiveRecord::IrreversibleMigration
      end
  end
end
