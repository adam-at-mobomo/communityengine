class AddLastLogin < ActiveRecord::Migration
  def self.up
    add_column :community_engine_users, :last_login_at, :datetime
  end

  def self.down
    remove_column :community_engine_users, :last_login_at
  end
end
