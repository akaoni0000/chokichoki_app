class Change108 < ActiveRecord::Migration[5.2]
  def change
    remove_column :hairdressers, :status, :string
    add_column :hairdressers, :judge_status, :boolean, default: false
  end
end
