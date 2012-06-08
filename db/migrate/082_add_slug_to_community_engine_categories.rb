class AddSlugToCommunityEngineCategories < ActiveRecord::Migration
  def change
    add_column :community_engine_categories, :slug, :string

  end
end
