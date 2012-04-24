module CommunityEngine
class CategoriesController < BaseController
  before_filter :login_required, :except => [:show, :most_viewed, :rss]
  before_filter :admin_required, :only => [:new, :edit, :update, :create, :destroy, :index]
  
  # GET /categories
  # GET /categories.xml
  def index
    @categories = CommunityEngine::Category.all

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @categories.to_xml }
    end
  end
  
  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = CommunityEngine::Category.find(params[:id])
    @sidebar_right = true
      
    order = (params[:popular] ? "view_count #{params[:popular].eql?('DESC') ? 'DESC' : 'ASC'}": "published_at DESC")

    @posts = CommunityEngine::Post.includes(:tags).where('category_id = ?', @category.id).order(order).page(params[:page])
    
    @popular_posts = @category.posts.order("view_count DESC").all(:limit => 10)
    @popular_polls = CommunityEngine::Poll.find_popular_in_category(@category)

    @rss_title = "#{configatron.community_name}: #{@category.name} "+:posts.l
    @rss_url = category_path(@category, :format => :rss)

    @active_users = CommunityEngine.user_class.all(:include => :posts,
      :limit => 5,
      :conditions => ["community_engine_posts.category_id = ? AND community_engine_posts.published_at > ?", @category.id, 14.days.ago],
      :order => "community_engine_users.view_count DESC"
      )
    
    respond_to do |format|
      format.html # show.rhtml
      format.rss {
        render_rss_feed_for(@posts, {:feed => {:title => "#{configatron.community_name}: #{@category.name} "+:posts.l, :link => category_url(@category)},
          :item => {:title => :title,
                    :link =>  Proc.new {|post| user_post_url(post.user, post)},
                    :description => :post,
                    :pub_date => :published_at} })
      }
    end
  end 
    
  # GET /categories/new
  def new
    @category = CommunityEngine::Category.new
  end
  
  # GET /categories/1;edit
  def edit
    @category = CommunityEngine::Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = CommunityEngine::Category.new(params[:category])
    
    respond_to do |format|
      if @category.save
        flash[:notice] = :category_was_successfully_created.l
        
        format.html { redirect_to category_url(@category) }
        format.xml do
          headers["Location"] = category_url(@category)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors.to_xml }
      end
    end
  end
  
  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = CommunityEngine::Category.find(params[:id])
    
    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to category_url(@category) }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors.to_xml }        
      end
    end
  end
  
  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = CommunityEngine::Category.find(params[:id])
    @category.destroy
    
    respond_to do |format|
      format.html { redirect_to categories_url   }
      format.xml  { render :nothing => true }
    end
  end
  
  def show_tips
    @category = CommunityEngine::Category.find(params[:id] )
    render :partial => "community_engine/categories/tips", :locals => {:category => @category}
  rescue ActiveRecord::RecordNotFound
    render :partial => "community_engine/categories/tips", :locals => {:category => nil}
  end
  
  
end
end