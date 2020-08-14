class Change234824141 < ActiveRecord::Migration[5.2]
  def change
      add_column :user_chats, :speaker, :string
      add_column :hairdresser_chats, :speaker, :string
  end
end
