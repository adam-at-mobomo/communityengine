module CommunityEngine
class PostSweeper < ActionController::Caching::Sweeper
  observe CommunityEngine::Post # This sweeper is going to keep an eye on the Post model

  # If our sweeper detects that a Post was created call this
  def after_create(post)
    expire_cache_for(post)
  end
  
  # If our sweeper detects that a Post was updated call this
  def after_update(post)
    expire_cache_for(post)
  end
  
  # If our sweeper detects that a Post was deleted call this
  def after_destroy(post)
    expire_cache_for(post)
  end
          
  private
  def expire_cache_for(record)
    # Expire the home page
    expire_action(:controller => 'base', :action => 'site_index', :module => "community_engine")

    # Expire the footer content
    expire_action(:controller => 'base', :action => 'footer_content', :module => "community_engine")
    
    # Also expire the sitemap
    expire_action(:controller => 'sitemap', :action => 'index', :module => "community_engine")

    # Expire the category pages
    expire_action(:controller => 'categories', :action => 'show', :module => "community_engine")

    # Also expire the show pages, in case we just edited a blog entry
    expire_action(:controller => 'posts', :action => 'show', :id => record.to_param, :user_id => record.user.to_param, :module => "community_engine")
  end
end
end