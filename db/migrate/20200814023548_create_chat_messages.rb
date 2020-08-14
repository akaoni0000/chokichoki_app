class CreateChatMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_messages do |t|
      
      t.integer :user_id
      t.integer :hairdresser_id
      t.integer :room_id
      t.string :message
      t.timestamps
    end
  end
end
