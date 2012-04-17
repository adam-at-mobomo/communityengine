class AddCommentNotificationToggle < ActiveRecord::Migration
  def self.up
    add_column :community_engine_posts, :send_comment_notifications, :boolean, :default => true
  end

  def self.down
    remove_column :community_engine_posts, :send_comment_notifications
  end
end