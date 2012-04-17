class AddTagSupport < ActiveRecord::Migration
  def self.up
    #Table for your Tags
    create_table :community_engine_tags do |t|
      t.column :name, :string
    end

    create_table :community_engine_taggings do |t|
      t.column :tag_id, :integer
      #id of tagged object
      t.column :taggable_id, :integer
      #type of object tagged
      t.column :taggable_type, :string
    end
  end

  def self.down
    drop_table :community_engine_tags
    drop_table :community_engine_taggings
  end
end