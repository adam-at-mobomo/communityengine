module CommunityEngine
class State < ActiveRecord::Base
  has_many :metro_areas, :class_name => 'CommunityEngine::MetroArea'
  has_many :users, :class_name => CommunityEngine.user_class_name
  # belongs_to :country, :class_name => 'CommunityEngine::Country'
end
end