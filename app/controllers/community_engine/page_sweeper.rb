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
    expire_action(:controller => 'base', :action => 'site_index', :module => 'community_engine')

    # Expire the footer content
    expire_action(:controller => 'base', :action => 'footer_content', :module => 'community_engine')
    
    # Also expire the sitemap
    expire_action(:controller => 'sitemap', :action => 'index', :module => 'community_engine')

    # Also expire the show pages, in case we just edited/deleted a page
    expire_action(:controller => 'pages', :action => 'show', :id => record.to_param, :module => 'community_engine')
  end
end
end