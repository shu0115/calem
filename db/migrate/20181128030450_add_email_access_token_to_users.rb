class AddEmailAccessTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email, :string
    add_column :users, :access_token, :string
    add_column :users, :access_token_expired_at, :datetime
    add_column :users, :active_flag, :boolean, default: false

    add_index :users, :email, unique: true
    add_index :users, :access_token, unique: true
  end
end
