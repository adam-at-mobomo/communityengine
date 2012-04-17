class CreateCommunityEngineAlbums < ActiveRecord::Migration
  def self.up
    create_table :community_engine_albums do |t|
      t.string :title
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :community_engine_albums
  end
end
