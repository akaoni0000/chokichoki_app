class Change3 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdressers, :point, :integer, default: 0
  end
end
