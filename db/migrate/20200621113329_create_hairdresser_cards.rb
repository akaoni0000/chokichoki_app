class CreateHairdresserCards < ActiveRecord::Migration[5.2]
  def change
    create_table :hairdresser_cards do |t|
      
      t.integer :hairdresser_id
      t.string :customer_id
      t.string :card_id
      t.timestamps
    end
  end
end
