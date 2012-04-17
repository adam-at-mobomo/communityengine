class AddTaggingsCountToCommunityEngineTags < ActiveRecord::Migration
  def self.up
    add_column :community_engine_tags, :taggings_count, :integer, :default => 0
  end
  
  def self.down
    remove_column :community_engine_tags, :taggings_count
  end
end
