module CommunityEngine
class Moderatorship < ActiveRecord::Base
  belongs_to :forum, :class_name => 'CommunityEngine::Forum'
  belongs_to :user, :class_name => CommunityEngine.user_class_name
  validates_presence_of :user, :forum

  validates_uniqueness_of :user_id, :scope => :forum_id

end
end