class Change23121321 < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :reservation_id, :integer
  end
end
