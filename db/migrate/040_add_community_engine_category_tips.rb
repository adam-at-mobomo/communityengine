class AddCommunityEngineCategoryTips < ActiveRecord::Migration
  def self.up
    add_column :community_engine_categories, :tips, :text
  end

  def self.down    
    remove_column :community_engine_categories, :tips
  end
end
