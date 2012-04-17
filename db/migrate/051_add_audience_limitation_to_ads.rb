class AddAudienceLimitationToAds < ActiveRecord::Migration
  def self.up
    add_column :community_engine_ads, :audience, :string, :default => 'all'
  end

  def self.down
    remove_column :community_engine_ads, :audience
  end
end
