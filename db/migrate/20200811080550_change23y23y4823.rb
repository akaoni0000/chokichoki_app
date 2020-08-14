class Change23y23y4823 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdresser_chat_rooms, :room_id, :integer
    add_column :user_chat_rooms, :room_id, :integer
  end
end
