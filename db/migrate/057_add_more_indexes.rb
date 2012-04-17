class AddMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :community_engine_posts, :published_at
    add_index :community_engine_posts, :published_as
    add_index :community_engine_polls, :created_at    
    add_index :community_engine_polls, :post_id
    add_index :community_engine_activities, :created_at
    add_index :community_engine_activities, :user_id
  end
  
  def self.down
    remove_index :community_engine_posts, :published_at
    remove_index :community_engine_posts, :published_as        
    remove_index :community_engine_polls, :created_at    
    remove_index :community_engine_polls, :post_id        
    remove_index :community_engine_activities, :created_at
    remove_index :community_engine_activities, :user_id
  end  
end
