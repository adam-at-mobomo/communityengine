module CommunityEngine.user_classsHelper
  def friends?(user, friend)
    CommunityEngine::Friendship.friends?(user, friend)
  end    
      
end
