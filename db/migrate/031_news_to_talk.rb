class NewsToTalk < ActiveRecord::Migration
  def self.up
    # Not in a migration!
    # category = CommunityEngine::Category.create(:name => "Talk")
  end

  def self.down
    # CommunityEngine::Category.find_by_name("Talk").destroy
  end
end
