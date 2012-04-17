class MigrateToActsAsTaggableOn < ActiveRecord::Migration
  
  def self.up

    change_table :community_engine_taggings do |t|
      t.references :tagger, :polymorphic => true
      t.string :context, :limit => 128
      t.datetime :created_at      
    end
    
    add_index :community_engine_taggings, [:taggable_id, :taggable_type, :context]
  end  
  
  def self.down
    
  end
  
end