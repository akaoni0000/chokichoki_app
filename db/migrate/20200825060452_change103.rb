class Change103 < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :phone_number, :string
    add_column :users, :activation_digest, :string, unique: true
    add_column :users, :activation_status, :boolean
    add_column :users, :activation_deadline_at, :datetime
    add_column :users, :password_reset_digest, :string
    add_column :users, :password_reset_deadline_at, :datetime
  end
end
