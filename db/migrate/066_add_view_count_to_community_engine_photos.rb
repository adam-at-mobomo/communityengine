class AddViewCountToCommunityEnginePhotos < ActiveRecord::Migration
  def self.up
    add_column :community_engine_photos, :view_count, :integer
  end

  def self.down
    remove_column :community_engine_photos, :view_count
  end
end
