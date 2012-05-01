module CommunityEngine
class Country < ActiveRecord::Base
  has_many :metro_areas, :class_name => 'CommunityEngine::MetroArea'
  has_many :users, :class_name => CommunityEngine.user_class_name
  
  def self.get(name)
    case name
      when :us
        c = 'United States'
    end
    self.find_by_name(c)
  end
  
  def self.find_countries_with_metros
    CommunityEngine::Country.joins(:metro_areas).where('community_engine_metro_areas.id IS NOT NULL').order('community_engine_countries.name ASC').all.uniq
  end
  
  def states
    CommunityEngine::State.joins(:metro_areas).where("community_engine_metro_areas.id in (?)", metro_area_ids ).order('community_engine_states.name ASC').all.uniq
  end
  
  def metro_area_ids
    metro_areas.map{|m| m.id }.to_ary
  end
  
end
end