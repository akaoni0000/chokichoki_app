class Change2rqr414r1 < ActiveRecord::Migration[5.2]
  def change
    remove_column :hairdressers, :style_images, :string
  end
end
