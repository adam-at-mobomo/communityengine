#hack to get around the fact that the StaticPage model no longer exists
class CommunityEngine::StaticPage < ActiveRecord::Base
end


class CreateCommunityEnginePages < ActiveRecord::Migration
  def self.up    
    create_table :community_engine_pages do |t|
      t.string :title
      t.text :body
      t.string :published_as, :limit => 16, :default => 'draft'
      t.boolean :page_public, :default => true
      t.timestamps
    end
    
    #remove static pages table id needed and migrate StaticPages to Pages
    if ActiveRecord::Base.connection.tables.include?('community_engine_static_pages')
      CommunityEngine::StaticPage.all.each do |page|
        CommunityEngine::Page.create(:title => page.title, :body => page.content, :published_as=>"live", :page_public => true)
      end

      drop_table :community_engine_static_pages          
    end
  end

  def self.down
    drop_table :community_engine_pages
  end
end
