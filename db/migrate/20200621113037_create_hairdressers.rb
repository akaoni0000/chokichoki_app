class CreateHairdressers < ActiveRecord::Migration[5.2]
  def change
    create_table :hairdressers do |t|
      
      t.string :name
      t.string :email
      t.text :introduction
      t.string :address
      t.string :shop_name
      t.string :confirm_image_id
      t.integer :status, default: 0
      t.string :hairdresser_image_id
      t.integer :point
      t.timestamps
    end
  end
end
