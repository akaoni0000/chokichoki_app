class Change32384 < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_cancels
  end
end
