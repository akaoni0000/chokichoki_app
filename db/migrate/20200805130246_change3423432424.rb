class Change3423432424 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdressers, :shop_latitude, :float
    add_column :hairdressers, :shop_longitude, :float
  end
end
