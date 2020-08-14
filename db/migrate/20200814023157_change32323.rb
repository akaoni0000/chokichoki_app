class Change32323 < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_chats
    drop_table :hairdresser_chats
  end
end
