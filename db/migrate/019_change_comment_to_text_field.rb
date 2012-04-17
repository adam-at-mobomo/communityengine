class ChangeCommentToTextField < ActiveRecord::Migration
  def self.up
    remove_column "community_engine_comments", "comment"
    add_column "community_engine_comments", "comment", :text        
  end

  def self.down
    change_column "community_engine_comments", "comment", :string, :default => ""
  end
end
