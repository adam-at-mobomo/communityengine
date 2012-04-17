class AddCommunityEngineSessionsTable < ActiveRecord::Migration
  
  def self.up
    create_table :community_engine_sessions do |t| 
      t.column :sessid, :string 
      t.column :data, :text 
      t.column :updated_at, :datetime 
      t.column :created_at, :datetime 
    end
    add_index :community_engine_sessions, :sessid
  end

  def self.down
    remove_index :community_engine_sessions, :sessid
    drop_table :community_engine_sessions
  end
  
end


