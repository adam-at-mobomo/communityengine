class CreateCommunityEngineSlugs < ActiveRecord::Migration
  def self.up
    create_table :community_engine_slugs do |t|
      t.string :name
      t.integer :sluggable_id
      t.integer :sequence, :null => false, :default => 1
      t.string :sluggable_type, :limit => 40
      t.string :scope
      t.datetime :created_at
    end
    add_index :community_engine_slugs, :sluggable_id
    add_index :community_engine_slugs, [:name, :sluggable_type, :sequence, :scope], :name => "index_community_engine_slugs_on_n_s_s_and_s", :unique => true
  end

  def self.down
    drop_table :community_engine_slugs
  end
end
