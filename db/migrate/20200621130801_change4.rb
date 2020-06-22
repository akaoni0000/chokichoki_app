class Change4 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :point, :integer, default: 0
  end
end
