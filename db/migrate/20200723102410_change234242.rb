class Change234242 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdressers, :reject_status, :integer
  end
end
