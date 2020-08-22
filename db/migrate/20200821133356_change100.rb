class Change100 < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_messages, :notification, :boolean, default: false, null: false
  end
end
