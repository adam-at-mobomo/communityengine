class AddCountryIdToCommunityEngineUsers < ActiveRecord::Migration
  def self.up
    add_column :community_engine_users, :country_id, :integer
  end

  def self.down
    remove_column :community_engine_users, :country_id
  end
end
