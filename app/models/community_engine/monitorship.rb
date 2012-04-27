module CommunityEngine
class Monitorship < ActiveRecord::Base
  belongs_to :user, :class_name => CommunityEngine.user_class_name
  belongs_to :topic, :class_name => 'CommunityEngine::Topic'
  validates_presence_of :user, :topic
  validates_uniqueness_of :user_id, :scope => :topic_id
end
end