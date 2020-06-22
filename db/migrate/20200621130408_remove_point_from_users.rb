class RemovePointFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :point, :integer
  end
end
