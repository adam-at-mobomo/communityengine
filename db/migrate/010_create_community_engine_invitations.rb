class CreateCommunityEngineInvitations < ActiveRecord::Migration
  def self.up
    create_table :community_engine_invitations do |t|
      t.column "email_addresses", :string
      t.column "message", :string
      t.column "user_id", :integer      
      t.column "created_at", :datetime
    end
  end

  def self.down
    drop_table :community_engine_invitations
  end
end
