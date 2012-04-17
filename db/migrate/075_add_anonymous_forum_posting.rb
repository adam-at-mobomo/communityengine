class AddAnonymousForumPosting < ActiveRecord::Migration
  def self.up
    add_column :community_engine_sb_posts, :author_name, :string
    add_column :community_engine_sb_posts, :author_email, :string
    add_column :community_engine_sb_posts, :author_url, :string
    add_column :community_engine_sb_posts, :author_ip, :string

  end
  
  def self.down
    remove_column :community_engine_sb_posts, :author_name
    remove_column :community_engine_sb_posts, :author_email
    remove_column :community_engine_sb_posts, :author_url
    remove_column :community_engine_sb_posts, :author_ip
  end
end
