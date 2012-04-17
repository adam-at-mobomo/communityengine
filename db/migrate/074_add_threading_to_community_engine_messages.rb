class AddThreadingToCommunityEngineMessages < ActiveRecord::Migration
  def self.up
    add_column :community_engine_messages, :parent_id, :integer

    create_table :community_engine_message_threads do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :message_id
      t.integer :parent_message_id
      t.timestamps
    end
        
  end
  
  def self.down
    remove_column :community_engine_messages, :parent_id
    drop_table :community_engine_message_threads
  end
end
