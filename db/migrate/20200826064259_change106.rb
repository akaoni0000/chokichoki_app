class Change106 < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :model_status, :integer
  end
end
