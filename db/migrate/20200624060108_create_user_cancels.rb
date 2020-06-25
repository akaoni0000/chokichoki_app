class CreateUserCancels < ActiveRecord::Migration[5.2]
  def change
    create_table :user_cancels do |t|
      t.integer "menu_id"
      t.integer "user_id"
      t.datetime "start_time"
      t.timestamps
    end
  end
end
