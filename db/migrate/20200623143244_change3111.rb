class Change3111 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdressers, :point, :integer, default: 500
  end
end
