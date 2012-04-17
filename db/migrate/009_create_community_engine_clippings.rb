class CreateCommunityEngineClippings < ActiveRecord::Migration
  def self.up
    create_table :community_engine_clippings do |t|
      t.column :url, :string
      t.column :user_id, :integer
      t.column :image_url, :string
      t.column :description, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :community_engine_clippings
  end
end
