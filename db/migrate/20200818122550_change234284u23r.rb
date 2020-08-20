class Change234284u23r < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_messages, :image_id, :string
  end
end
