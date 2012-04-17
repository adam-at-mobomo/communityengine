class StillMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :community_engine_posts, :user_id
    add_index :community_engine_tags, :name    
    add_index :community_engine_taggings, [:taggable_id, :taggable_type]
    add_index :community_engine_photos, :created_at
    add_index :community_engine_users, :created_at
    add_index :community_engine_clippings, :created_at
  end

  def self.down
    remove_index :community_engine_posts, :user_id        
    remove_index :community_engine_tags, :name
    remove_index :community_engine_taggings, :column => [:taggable_id, :taggable_type]
    remove_index :community_engine_photos, :created_at    
    remove_index :community_engine_users, :created_at
    remove_index :community_engine_clippings, :created_at
  end
end
