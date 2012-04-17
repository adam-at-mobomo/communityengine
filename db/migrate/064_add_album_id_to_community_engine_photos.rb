class AddAlbumIdToCommunityEnginePhotos < ActiveRecord::Migration
  def self.up
    add_column :community_engine_photos, :album_id, :integer
  end

  def self.down
    remove_column :community_engine_photos, :album_id
  end
end
