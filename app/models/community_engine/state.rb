module CommunityEngine
class State < ActiveRecord::Base
  has_many :metro_areas, :class_name => 'CommunityEngine::MetroArea'
  # belongs_to :country, :class_name => 'CommunityEngine::Country'
end
end