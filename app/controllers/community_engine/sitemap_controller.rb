module CommunityEngine
class SitemapController < BaseController
  layout false
  caches_action :index

  def index
    @users = CommunityEngine.user_class.active.select('id, login, updated_at, login_slug')
    @posts = CommunityEngine::Post.select("community_engine_posts.id, community_engine_posts.user_id, community_engine_posts.published_as, community_engine_posts.published_at, #{CommunityEngine.user_class.table_name}.id, #{CommunityEngine.user_class.table_name}.login_slug").joins(:user)   #"LEFT JOIN users ON users.id = posts.user_id")

    @categories = Category.find(:all)
  
    respond_to do |format|
      format.html {
        render :layout => 'application'
      }
      format.xml 
    end
  end
  
  
  
end
end