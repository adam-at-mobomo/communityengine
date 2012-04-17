class AddPublishedAtToCommunityEnginePosts < ActiveRecord::Migration
  def self.up
    add_column :community_engine_posts, :published_at, :datetime

    # Update all existing published posts
    # Set published_at to created_at date for posts that were already published
    # Nope.
    # Post.update_all("published_at = created_at", "published_as = 'live'")
  end

  def self.down
    remove_column :community_engine_posts, :published_at
  end

end
