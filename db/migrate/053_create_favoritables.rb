class CreateFavoritables < ActiveRecord::Migration
  def self.up
    create_table :community_engine_favorites do |t|
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
      t.column :favoritable_type, :string
      t.column :favoritable_id, :integer
      t.column :user_id, :integer
      t.column :ip_address, :string, :default => ''
    end

    add_column :community_engine_clippings,  :favorited_count, :integer, :default => 0
    add_column :community_engine_posts,      :favorited_count, :integer, :default => 0    

    add_index :community_engine_favorites, [:user_id], :name => "fk_community_engine_favorites_user"
  end

  def self.down
    drop_table :community_engine_favorites
    remove_column :community_engine_clippings, :favorited_count
    remove_column :community_engine_posts, :favorited_count    
  end
end