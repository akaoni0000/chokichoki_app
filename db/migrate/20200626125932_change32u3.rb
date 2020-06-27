class Change32u3 < ActiveRecord::Migration[5.2]

  def up
    drop_table :hairdresser_cards
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
