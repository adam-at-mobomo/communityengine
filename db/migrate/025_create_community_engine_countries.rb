class CreateCommunityEngineCountries < ActiveRecord::Migration
  def self.up
    create_table :community_engine_countries do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :community_engine_countries
  end
end
