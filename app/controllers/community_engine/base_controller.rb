require 'hpricot'
require 'open-uri'
require 'pp'

class CommunityEngine::BaseController < ApplicationController

  include AuthenticatedSystem
  include LocalizedApplication
  around_filter :set_locale  
  skip_before_filter :verify_authenticity_token, :only => :footer_content
  helper_method :commentable_url, :logged_in?
  before_filter :initialize_header_tabs
  before_filter :initialize_admin_tabs
  before_filter :store_location

  caches_action :site_index, :footer_content, :if => Proc.new{|c| c.cache_action? }
  
  # Needed to support code written to use this method from AuthenticatedSystem
  def logged_in?
    !current_user.nil?
  end
  
  def cache_action?
    !logged_in? && controller_name.eql?('base') && params[:format].blank? 
  end  
  
  def rss_site_index
    redirect_to :controller => 'base', :action => 'site_index', :format => 'rss'
  end
  
  def plaxo
    render :layout => false
  end

  def site_index
    @posts = CommunityEngine::Post.find_recent

    @rss_title = "#{configatron.community_name} "+:recent_posts.l
    @rss_url = rss_url
    respond_to do |format|
      format.html { get_additional_homepage_data }
      format.rss do
        render_rss_feed_for(@posts, { :feed => {:title => "#{configatron.community_name} "+:recent_posts.l, :link => recent_url},
                              :item => {:title => :title,
                                        :link =>  Proc.new {|post| user_post_url(post.user, post)},
                                         :description => :post,
                                         :pub_date => :published_at}
          })
      end
    end    
  end
  
  def footer_content
    get_recent_footer_content 
    render :partial => 'shared/footer_content' and return    
  end
  
  def homepage_features
    @homepage_features = CommunityEngine::HomepageFeature.find_features
    @homepage_features.shift
    render :partial => 'homepage_feature', :collection => @homepage_features and return
  end
    
  def advertise
  end
  
  def css_help
  end
  
  
  private
    def update_user_activity
      session[:last_active] = current_user.record.sb_last_seen_at
      session[:topics] = controller.session[:forums] = {}
      current_user.record.update_last_seen_at
    end
    
    def admin_required
      current_user && current_user.admin? ? true : access_denied
    end
  
    def admin_or_moderator_required
      current_user && (current_user.admin? || current_user.moderator?) ? true : access_denied
    end
  
    def find_user
      if @user = CommunityEngine::User.active.find(params[:user_id] || params[:id])
        @is_current_user = (@user && @user.eql?(current_user))
        unless logged_in? || @user.profile_public?
          flash[:error] = :private_user_profile_message.l
          access_denied 
        else
          return @user
        end
      else
        flash[:error] = :please_log_in.l
        access_denied
      end
    end
  
    def require_current_user
      @user ||= CommunityEngine::User.find(params[:user_id] || params[:id] )
      unless admin? || (@user && (@user.eql?(current_user)))
        redirect_to :controller => 'sessions', :action => 'new' and return false
      end
      return @user
    end

    def popular_tags(limit = 20, type = nil)
      ActsAsTaggableOn::Tag.popular(limit, type)
    end
  

    def get_recent_footer_content
      @recent_clippings = CommunityEngine::Clipping.find_recent(:limit => 10)
      @recent_photos = CommunityEngine::Photo.find_recent(:limit => 10)
      @recent_comments = CommunityEngine::Comment.find_recent(:limit => 13)
      @popular_tags = popular_tags(30)
      @recent_activity = CommunityEngine::User.recent_activity(:size => 15, :current => 1)
    
    end

    def get_additional_homepage_data
      @sidebar_right = true
      @homepage_features = CommunityEngine::HomepageFeature.find_features
      @homepage_features_data = @homepage_features.collect {|f| [f.id, f.image.url(:large) ]  }
    
      @active_users = CommunityEngine::User.find_by_activity({:limit => 5, :require_avatar => false})
      @featured_writers = CommunityEngine::User.find_featured

      @featured_posts = CommunityEngine::Post.find_featured
    
      @topics = CommunityEngine::Topic.find(:all, :limit => 5, :order => "replied_at DESC")

      @popular_posts = CommunityEngine::Post.find_popular({:limit => 10})    
      @popular_polls = CommunityEngine::Poll.find_popular(:limit => 8)
    end


    def commentable_url(comment)
      if comment.recipient && comment.commentable
        if comment.commentable_type != "User"
          polymorphic_url([comment.recipient, comment.commentable])+"#comment_#{comment.id}"
        elsif comment
          user_url(comment.recipient)+"#comment_#{comment.id}"
        end
      elsif comment.commentable
        polymorphic_url(comment.commentable)+"#comment_#{comment.id}"      
      end
    end
    
    def initialize_header_tabs
      # This hook allows plugins or host apps to easily add tabs to the header by adding to the @header_tabs array
      # Usage: @header_tabs << {:name => "My tab", :url => my_tab_path, :section => 'my_tab_section' }
      @header_tabs = []      
    end 
    def initialize_admin_tabs
      # This hook allows plugins or host apps to easily add tabs to the admin nav by adding to the @admin_nav_links array
      # Usage: @admin_nav_links << {:name => "My link", :url => my_link_path,  }
      @admin_nav_links = []      
    end 

end
