class Change3232 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdresser_comments, :menu_id, :integer
    add_column :hairdresser_comments, :start_tiem, :datetime
  end
end
