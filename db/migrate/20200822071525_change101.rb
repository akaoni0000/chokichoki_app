class Change101 < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :room_token, :string
  end
end
