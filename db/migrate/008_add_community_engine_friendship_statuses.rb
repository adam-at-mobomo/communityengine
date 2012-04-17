class AddCommunityEngineFriendshipStatuses < ActiveRecord::Migration
  def self.up
    CommunityEngine::FriendshipStatus.enumeration_model_updates_permitted = true    
    CommunityEngine::FriendshipStatus.create :name => "pending"
    CommunityEngine::FriendshipStatus.create :name => "accepted"
    CommunityEngine::FriendshipStatus.enumeration_model_updates_permitted = false
  end

  def self.down
    CommunityEngine::FriendshipStatus.enumeration_model_updates_permitted = true    
    CommunityEngine::FriendshipStatus.destroy_all
    CommunityEngine::FriendshipStatus.enumeration_model_updates_permitted = false
  end
end
