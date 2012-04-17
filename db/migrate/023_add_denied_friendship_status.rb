class AddDeniedFriendshipStatus < ActiveRecord::Migration
  def self.up
    CommunityEngine::FriendshipStatus.enumeration_model_updates_permitted = true    
    CommunityEngine::FriendshipStatus.create :name => "denied"
    CommunityEngine::FriendshipStatus.enumeration_model_updates_permitted = false
  end

  def self.down
    CommunityEngine::FriendshipStatus.enumeration_model_updates_permitted = true    
    CommunityEngine::FriendshipStatus.find_by_name('denied').destroy
    CommunityEngine::FriendshipStatus.enumeration_model_updates_permitted = false
  end
end
