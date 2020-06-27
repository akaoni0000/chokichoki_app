class Change321 < ActiveRecord::Migration[5.2]
  def change
    remove_column :hairdresser_comments, :start_tiem, :datetime
    add_column :hairdresser_comments, :start_time, :datetime
  end
end
