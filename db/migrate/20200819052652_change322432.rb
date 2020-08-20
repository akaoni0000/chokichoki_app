class Change322432 < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_messages, :style_images, :string
  end
end
