class Change3y283 < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_chat_rooms
    drop_table :hairdresser_chat_rooms
  end
end
