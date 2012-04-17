class AddActivitiesCount < ActiveRecord::Migration
  def self.up
    add_column :community_engine_users, :activities_count, :integer, :default => 0
  end

  def self.down
    remove_column :community_engine_users, :activities_count
  end
end