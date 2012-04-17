class AddActivationCodeToCommunityEngineUser < ActiveRecord::Migration
  def self.up
    add_column :community_engine_users, :activation_code, :string, :limit => 40
    add_column :community_engine_users, :activated_at, :datetime
  end

  def self.down
    remove_column "community_engine_users", "activation_code"
    remove_column "community_engine_users", "activated_at"
  end
end
