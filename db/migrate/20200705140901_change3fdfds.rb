class Change3fdfds < ActiveRecord::Migration[5.2]
  def change
    remove_column :hairdressers, :point, :integer
  end
end
