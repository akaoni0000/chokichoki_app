class Change341 < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :point, :integer
    add_column :users, :point, :integer, default: 500
  end
end
