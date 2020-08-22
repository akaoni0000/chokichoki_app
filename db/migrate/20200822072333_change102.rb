class Change102 < ActiveRecord::Migration[5.2]
  def change
    remove_column :rooms, :room_token, :string
    add_column :rooms, :room_token, :string, unique: true
  end
end
