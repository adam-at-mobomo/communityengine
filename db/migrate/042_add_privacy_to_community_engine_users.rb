class AddPrivacyToCommunityEngineUsers < ActiveRecord::Migration
  def self.up
    add_column :community_engine_users, :profile_public, :boolean, :default => true
  end

  def self.down
    remove_column :community_engine_users, :profile_public
  end

end
