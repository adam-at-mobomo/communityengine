class AddUsToExistingMetroAreas < ActiveRecord::Migration
  def self.up
    CommunityEngine::MetroArea.update_all(:country_id => CommunityEngine::Country.get(:us))
  end

  def self.down
    CommunityEngine::MetroArea.update_all(:country_id => nil)
  end
end
