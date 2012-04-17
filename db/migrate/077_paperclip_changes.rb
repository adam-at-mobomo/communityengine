class PaperclipChanges < ActiveRecord::Migration
  def up
    rename_column :community_engine_photos, :filename, :photo_file_name
    rename_column :community_engine_photos, :content_type, :photo_content_type
    rename_column :community_engine_photos, :size, :photo_file_size
    add_column :community_engine_photos, :photo_updated_at, :datetime
        
    rename_column :community_engine_assets, :filename, :asset_file_name
    rename_column :community_engine_assets, :content_type, :asset_content_type
    rename_column :community_engine_assets, :size, :asset_file_size        
    add_column :community_engine_assets, :asset_updated_at, :datetime       
    
    rename_column :community_engine_homepage_features, :filename, :image_file_name
    rename_column :community_engine_homepage_features, :content_type, :image_content_type
    rename_column :community_engine_homepage_features, :size, :image_file_size        
    add_column :community_engine_homepage_features, :image_updated_at, :datetime       
  end

  def down
    rename_column :community_engine_photos, :photo_file_name, :filename
    rename_column :community_engine_photos, :photo_content_type, :content_type
    rename_column :community_engine_photos, :photo_file_size, :size
    remove_column :community_engine_photos, :photo_updated_at
        
    rename_column :community_engine_assets, :asset_file_name, :filename
    rename_column :community_engine_assets, :asset_content_type, :content_type
    rename_column :community_engine_assets, :asset_file_size, :size
    remove_column :community_engine_assets, :asset_updated_at    
    
    rename_column :community_engine_homepage_feature, :image_file_name, :filename
    rename_column :community_engine_homepage_feature, :image_content_type, :content_type
    rename_column :community_engine_homepage_feature, :image_file_size, :size
    remove_column :community_engine_homepage_feature, :image_updated_at    
    
  end
end
