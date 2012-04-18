class AuthlogicCompatibilityChanges < ActiveRecord::Migration
  def self.up
    change_column :community_engine_users, :crypted_password, :string, :limit => 255
    change_column :community_engine_users, :salt, :string, :limit => 255

    rename_column :community_engine_users, :salt, :password_salt
    rename_column :community_engine_users, :remember_token, :persistence_token

    remove_column :community_engine_users, :remember_token_expires_at

    change_table :community_engine_users do |t|
      t.column :single_access_token, :string
      t.column :perishable_token, :string
      t.column :login_count,         :integer, :default => 0 
      t.column :failed_login_count,  :integer, :default => 0 
      t.column :last_request_at,     :datetime               
      t.column :current_login_at,    :datetime               
      t.column :current_login_ip,    :string                 
      t.column :last_login_ip,       :string                 
    end

    add_index :community_engine_users, :login
    add_index :community_engine_users, :persistence_token
    add_index :community_engine_users, :last_request_at
  end

  def self.down
    remove_index :community_engine_users, :login
    remove_index :community_engine_users, :persistence_token
    remove_index :community_engine_users, :last_request_at

    change_table :community_engine_users do |t|
      t.remove :single_access_token, :perishable_token, :login_count, :failed_login_count,
        :last_request_at, :current_login_at, :current_login_ip, :last_login_ip
    end

    rename_column :community_engine_users, :persistence_token, :remember_token

    add_column :community_engine_users, :remember_token_expires_at, :datetime, :default => nil
    rename_column :community_engine_users, :password_salt, :salt
  end

end
