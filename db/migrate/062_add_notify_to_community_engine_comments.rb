class AddNotifyToCommunityEngineComments < ActiveRecord::Migration
  
  def self.up
    add_column :community_engine_comments, :notify_by_email, :boolean, :default => true
  end
  
  def self.down
    remove_column :community_engine_comments, :notify_by_email
  end

end
