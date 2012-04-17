class AddingIndexes < ActiveRecord::Migration
  def self.up
    add_index :community_engine_comments, :recipient_id
    add_index :community_engine_photos, :parent_id
    add_index :community_engine_taggings, :tag_id
    add_index :community_engine_comments, :created_at
    add_index :community_engine_users, :avatar_id
    add_index :community_engine_users, :featured_writer    
    add_index :community_engine_comments, :commentable_type
    add_index :community_engine_comments, :commentable_id    
    add_index :community_engine_taggings, :taggable_type
    add_index :community_engine_taggings, :taggable_id    
    add_index :community_engine_users, :activated_at
    add_index :community_engine_users, :vendor
    add_index :community_engine_posts, :category_id
    add_index :community_engine_users, :login_slug
    add_index :community_engine_friendships, :user_id
    add_index :community_engine_friendships, :friendship_status_id  
  end

  def self.down
    remove_index :community_engine_comments, :recipient_id
    remove_index :community_engine_photos, :parent_id
    remove_index :community_engine_taggings, :tag_id
    remove_index :community_engine_comments, :created_at
    remove_index :community_engine_users, :avatar_id
    remove_index :community_engine_users, :featured_writer
    remove_index :community_engine_comments, :commentable_type
    remove_index :community_engine_comments, :commentable_id
    remove_index :community_engine_taggings, :taggable_type
    remove_index :community_engine_taggings, :taggable_id    
    remove_index :community_engine_users, :activated_at
    remove_index :community_engine_users, :vendor
    remove_index :community_engine_posts, :category_id
    remove_index :community_engine_users, :login_slug
    remove_index :community_engine_friendships, :user_id
    remove_index :community_engine_friendships, :friendship_status_id
  end
end
