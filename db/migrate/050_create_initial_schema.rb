class CreateInitialSchema < ActiveRecord::Migration
  def self.up
    create_table "community_engine_forums" do |t|
      t.column "name",             :string
      t.column "description",      :string
      t.column "topics_count",     :integer, :default => 0
      t.column "sb_posts_count",   :integer, :default => 0
      t.column "position",         :integer
      t.column "description_html", :text
      t.column "owner_type",       :string
      t.column "owner_id",         :integer
    end

    create_table "community_engine_moderatorships" do |t|
      t.column "forum_id", :integer
      t.column "user_id",  :integer
    end

    add_index "community_engine_moderatorships", ["forum_id"], :name => "index_community_engine_moderatorships_on_forum_id"

    create_table "community_engine_monitorships" do |t|
      t.column "topic_id", :integer
      t.column "user_id",  :integer
      t.column "active",   :boolean, :default => true
    end

    create_table "community_engine_sb_posts" do |t|
      t.column "user_id",    :integer
      t.column "topic_id",   :integer
      t.column "body",       :text
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "forum_id",   :integer
      t.column "body_html",  :text
    end

    add_index "community_engine_sb_posts", ["forum_id", "created_at"], :name => "index_community_engine_sb_posts_on_forum_id"
    add_index "community_engine_sb_posts", ["user_id", "created_at"], :name => "index_community_engine_sb_posts_on_user_id"

    create_table "community_engine_topics" do |t|
      t.column "forum_id",     :integer
      t.column "user_id",      :integer
      t.column "title",        :string
      t.column "created_at",   :datetime
      t.column "updated_at",   :datetime
      t.column "hits",         :integer,  :default => 0
      t.column "sticky",       :integer,  :default => 0
      t.column "sb_posts_count",  :integer,  :default => 0
      t.column "replied_at",   :datetime
      t.column "locked",       :boolean,  :default => false
      t.column "replied_by",   :integer
      t.column "last_post_id", :integer
    end

    add_column :community_engine_users, :sb_posts_count, :integer, :default => 0
    add_column :community_engine_users, :sb_last_seen_at, :datetime        

    add_index "community_engine_topics", ["forum_id"], :name => "index_topics_on_forum_id"
    add_index "community_engine_topics", ["forum_id", "sticky", "replied_at"], :name => "index_community_engine_topics_on_sticky_and_replied_at"
    add_index "community_engine_topics", ["forum_id", "replied_at"], :name => "index_community_engine_topics_on_forum_id_and_replied_at"    
  end

  def self.down
    drop_table :community_engine_topics
    drop_table :community_engine_sb_posts
    drop_table :community_engine_monitorships
    drop_table :community_engine_moderatorships
    drop_table :community_engine_forums   
    
    remove_column :community_engine_users, :sb_posts_count
    remove_column :community_engine_users, :sb_last_seen_at             
  end
end
