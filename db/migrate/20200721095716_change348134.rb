class Change348134 < ActiveRecord::Migration[5.2]
  def change
    add_column :user_cancels, :hairdresser_id, :integer
  end
end
