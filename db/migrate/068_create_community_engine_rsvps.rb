class CreateCommunityEngineRsvps < ActiveRecord::Migration
  def self.up
    create_table :community_engine_rsvps do |t|
      t.belongs_to :user, :event
      t.integer :attendees_count
      t.timestamps
    end
  end

  def self.down
    drop_table :community_engine_rsvps
  end
end
