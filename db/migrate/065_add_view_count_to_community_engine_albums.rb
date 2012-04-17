class AddViewCountToCommunityEngineAlbums < ActiveRecord::Migration
  def self.up
    add_column :community_engine_albums, :view_count, :integer
  end

  def self.down
    remove_column :community_engine_albums, :view_count
  end
end
