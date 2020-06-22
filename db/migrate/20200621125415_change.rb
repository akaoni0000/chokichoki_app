class Change < ActiveRecord::Migration[5.2]
  def change

    add_column :hairdressers, :password_digest, :string

  end
end
