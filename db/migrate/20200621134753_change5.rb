class Change5 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdressers, :post_number, :integer
  end
end
