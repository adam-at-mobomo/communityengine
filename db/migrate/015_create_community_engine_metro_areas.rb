class CreateCommunityEngineMetroAreas < ActiveRecord::Migration
  def self.up
    create_table :community_engine_metro_areas do |t|
      t.column :name, :string
      t.column :state_id, :integer
      t.column :country_id, :integer
    end
    add_column "community_engine_users", "metro_area_id", :integer
  end

  def self.down
    drop_table :community_engine_metro_areas
    remove_column "community_engine_users", "metro_area_id"
  end
end
