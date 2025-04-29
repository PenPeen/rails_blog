class AddDefinitiveToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :definitive, :boolean, default: false, after: :password_digest
  end
end
