class AddAllowRsvpToCommunityEngineEvents < ActiveRecord::Migration
  def self.up
    add_column :community_engine_events, :allow_rsvp, :boolean, :default => true
  end
  
  def self.down
    remove_column :community_engine_events, :allow_rsvp
  end
end
