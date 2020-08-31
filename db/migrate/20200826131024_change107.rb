class Change107 < ActiveRecord::Migration[5.2]
  def change
    add_column :hairdressers, :activation_digest, :string
    add_column :hairdressers, :activation_deadline_at, :datetime
    add_column :hairdressers, :password_reset_digest, :string
    add_column :hairdressers, :password_reset_deadline_at, :datetime
    add_column :hairdressers, :activation_status, :boolean, default: false
  end
end
