class Change384823 < ActiveRecord::Migration[5.2]
  def change
    remove_column :hairdressers, :reputation_point, :string, default: 0
    add_column :hairdressers, :reputation_point, :float, default: 0
  end
end
