module CommunityEngine
class FriendshipStatus < ActiveRecord::Base
  acts_as_enumerated
end
end