class AddUsersCounterCache < ActiveRecord::Migration
  def self.up
    add_column :community_engine_metro_areas, :users_count, :integer, :default => 0
  end

  def self.down
    remove_column :community_engine_metro_areas, :users_count
  end
end
