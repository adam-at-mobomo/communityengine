class AddZagToCommunityEngineUsers < ActiveRecord::Migration
  def self.up
    add_column :community_engine_users, :zip, :string
    add_column :community_engine_users, :birthday, :date
    add_column :community_engine_users, :gender, :string
  end

  def self.down
    remove_column :community_engine_users, :zip
    remove_column :community_engine_users, :birthday
    remove_column :community_engine_users, :gender
  end
end
