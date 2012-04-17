class CategoryImprovements < ActiveRecord::Migration
  def self.up
    add_column :community_engine_categories, :new_post_text, :string
    add_column :community_engine_categories, :nav_text, :string
  end

  def self.down
    remove_column :community_engine_categories, :new_post_text
    remove_column :community_engine_categories, :nav_text
  end
end
