class AddPasswordToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users do
      string 'password_digest', default: 'defaultPassword', null: false
    end
  end

  def down
    remove_column :users, :password_digest
  end
end
