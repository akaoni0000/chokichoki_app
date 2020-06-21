class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      
      t.integer :hairdresser_id
      t.integer :user_id
      t.string :name
      t.datetime :start_time
      t.integer :time
      t.text :user_repuest
      t.integer :sex_status, default: 0
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
