class Change23413414 < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :room_id, :integer
  end
end
