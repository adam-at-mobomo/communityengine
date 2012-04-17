class CreateCommunityEngineCategories < ActiveRecord::Migration
  def self.up
    create_table :community_engine_categories do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :community_engine_categories
  end
end
