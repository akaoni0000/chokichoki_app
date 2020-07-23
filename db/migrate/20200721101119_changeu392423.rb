class Changeu392423 < ActiveRecord::Migration[5.2]
  def change
    add_column :user_cancels, :notification_status, :integer, default: 0
  end
end
