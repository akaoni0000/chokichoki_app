class Change4334323 < ActiveRecord::Migration[5.2]
  def change
    remove_column :hairdressers, :reject_status, :integer
    add_column :hairdressers, :reject_status, :string
  end
end
