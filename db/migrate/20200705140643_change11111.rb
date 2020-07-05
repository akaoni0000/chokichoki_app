class Change11111 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdressers, :sex, :string
  end
end
