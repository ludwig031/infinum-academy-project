class AddSecureTokenToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :token, :string, index: { unique: true }
    User.all.each { |user| user.regenerate_token }
  end
  def down
    remove_column :users, :token
  end
end
