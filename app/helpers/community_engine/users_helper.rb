module CommunityEngine::UsersHelper
  def friends?(user, friend)
    CommunityEngine::Friendship.friends?(user, friend)
  end    
      
end
