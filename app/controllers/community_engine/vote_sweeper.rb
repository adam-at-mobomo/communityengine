module CommunityEngine
class VoteSweeper < ActionController::Caching::Sweeper
  observe CommunityEngine::Vote

  def after_create(vote)
    expire_cache_for(vote)
  end
              
  private
  def expire_cache_for(record)
    # Expire the home page
    expire_action(:controller => 'community_engine/base', :action => 'site_index')
       
    # Expire the show post page
    expire_page(:controller => 'community_engine/posts', :action => 'show', :id => record.id)
  end
end
end