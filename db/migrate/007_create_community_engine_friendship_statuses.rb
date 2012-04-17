class CreateCommunityEngineFriendshipStatuses < ActiveRecord::Migration
  def self.up
    create_table :community_engine_friendship_statuses do |t|
      t.column :name, :string
    end
    add_column "community_engine_friendships", "friendship_status_id", :integer
  end

  def self.down
    drop_table :community_engine_friendship_statuses
    remove_column "community_engine_friendships", "friendship_status_id"
  end
end
