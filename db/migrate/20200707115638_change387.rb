class Change387 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdressers, :reputation_point, :float, default: 0
  end
end
