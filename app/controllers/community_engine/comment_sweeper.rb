module CommunityEngine
class CommentSweeper < ActionController::Caching::Sweeper
  observe ::Comment

  def after_create(comment)
    expire_cache_for(comment)
  end
  
  # If our sweeper detects that a comment was updated call this
  def after_update(comment)
    expire_cache_for(comment)
  end
  
  # If our sweeper detects that a comment was deleted call this
  def after_destroy(comment)
    expire_cache_for(comment)
  end
          
  private
  def expire_cache_for(record)
    # Expire the footer content
    expire_action :controller => 'community_engine/base', :action => 'footer_content'

    if record.commentable_type.eql?('CommunityEngine::Post') 
      expire_action :controller => 'community_engine/posts', :action => 'show', :id => record.commentable.to_param , :user_id => record.commentable.user.to_param
      
      if CommunityEngine::Post.find_recent(:limit => 16).include?(record.commentable)
        # Expire the home page    
        expire_action :controller => 'community_engine/base', :action => 'site_index'
        # Expire the category pages
        expire_action :controller => 'community_engine/categories', :action => 'show', :id => record.commentable.category
      end
    end

  end
end
end