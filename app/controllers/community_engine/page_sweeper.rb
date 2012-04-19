module CommunityEngine
class PageSweeper < ActionController::Caching::Sweeper
  observe CommunityEngine::Page # This sweeper is going to keep an eye on the Page model

  # If our sweeper detects that a Page was created call this
  def after_create(page)
    expire_cache_for(page)
  end
  
  # If our sweeper detects that a Page was updated call this
  def after_update(page)
    expire_cache_for(page)
  end
  
  # If our sweeper detects that a Page was deleted call this
  def after_destroy(page)
    expire_cache_for(page)
  end
          
  private
  def expire_cache_for(record)
    # Expire the home page
    expire_action(:controller => 'community_engine/base', :action => 'site_index')

    # Expire the footer content
    expire_action(:controller => 'communitye_engine/base', :action => 'footer_content')
    
    # Also expire the sitemap
    expire_action(:controller => 'community_engine/sitemap', :action => 'index')

    # Also expire the show pages, in case we just edited/deleted a page
    expire_action(:controller => 'community_engine/pages', :action => 'show', :id => record.to_param)
  end
end
end