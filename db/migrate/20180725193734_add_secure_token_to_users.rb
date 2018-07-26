class AddSecureTokenToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :token, :string
    User.all.each { |user| user.regenerate_token }

    add_index :users, :token, unique: true
  end
  def down
    remove_column :users, :token
  end
end
