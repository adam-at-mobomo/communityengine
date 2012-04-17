class AddPolls < ActiveRecord::Migration
  def self.up
    create_table :community_engine_polls do |t|
      t.column :question,   :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :post_id, :integer
      t.column :votes_count, :integer, :default => 0
    end
    
    create_table :community_engine_choices do |t|
      t.column :poll_id, :integer
      t.column :description, :string
      t.column :votes_count, :integer, :default => 0
    end
    
    create_table :community_engine_votes do |t|
      t.column :user_id, :integer
      t.column :poll_id, :integer
      t.column :choice_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :community_engine_polls
    drop_table :community_engine_choices    
    drop_table :community_engine_votes    
  end
end