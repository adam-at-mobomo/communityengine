class CreateCommunityEngineStaticPages < ActiveRecord::Migration
  def self.up

    # Not using this anymore, but leaving the migration for compatibility

    # create_table :community_engine_static_pages do |t|
    #   t.string :title
    #   t.string :url
    #   t.text :content
    #   t.boolean :active, :default => false
    #   t.string :visibility, :default => 'Everyone' 
    # 
    #   t.timestamps
    # end
  end

  def self.down
    if ActiveRecord::Base.connection.tables.include?('community_engine_static_pages')    
      drop_table :community_engine_static_pages
    end
  end
end
