class CreateUserCards < ActiveRecord::Migration[5.2]
  def change
    create_table :user_cards do |t|

      t.integer :user_id
      t.string :customer_id
      t.string :card_id
      t.timestamps
    end
  end
end
