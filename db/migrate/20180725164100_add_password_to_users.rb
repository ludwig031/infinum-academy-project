class AddPasswordToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :password_digest, :string, default: 'defaultPassword'
  end

  def down
    remove_column :users, :password_digest
  end
end
