class Change112 < ActiveRecord::Migration[5.2]
  def change
    remove_column :hairdresser_comments, :rate, :float
    add_column :hairdresser_comments, :rate, :float, default: 0.0
  end
end
