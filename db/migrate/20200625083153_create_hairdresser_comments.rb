class CreateHairdresserComments < ActiveRecord::Migration[5.2]
  def change
    create_table :hairdresser_comments do |t|
      
      t.integer :hairdresser_id
      t.integer :user_id
      t.text :comment
      t.float :rate
      t.timestamps
    end
  end
end
