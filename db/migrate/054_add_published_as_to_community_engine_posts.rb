class AddPublishedAsToCommunityEnginePosts < ActiveRecord::Migration
  def self.up
    add_column :community_engine_posts, :published_as, :string, :limit => 16, :default => 'draft'
    # update all existing posts
    # Nope: not here. Do it in a rake task if you want.
    # Post.update_all("published_as = 'live'")
  end

  def self.down
    remove_column :community_engine_posts, :published_as
  end

end
