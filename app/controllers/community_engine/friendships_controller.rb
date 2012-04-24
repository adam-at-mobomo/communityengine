module CommunityEngine
class FriendshipsController < BaseController
  before_filter :login_required, :except => [:accepted, :index]
  before_filter :find_user, :only => [:accepted, :pending, :denied]
  before_filter :require_current_user, :only => [:accept, :deny, :pending, :destroy]

  def index
    @body_class = 'friendships-browser'
    
    @user = (params[:id] ||params[:user_id]) ? CommunityEngine::User.find((params[:id] || params[:user_id] )): CommunityEngine::Friendship.first.user
    @friendships = CommunityEngine::Friendship.all(:conditions => ['user_id = ? OR friend_id = ?', @user.id, @user.id], :limit => 40)
    @users = CommunityEngine::User.all(:conditions => ['community_engine_users.id in (?)', @friendships.collect{|f| f.friend_id }])    
    
    respond_to do |format|
      format.html 
      format.xml { render :action => 'index.rxml', :layout => false}    
    end
  end
  
  def deny
    @user = CommunityEngine::User.find(params[:user_id])    
    @friendship = @user.friendships.find(params[:id])
 
    respond_to do |format|
      if @friendship.update_attributes(:friendship_status => CommunityEngine::FriendshipStatus[:denied]) && @friendship.reverse.update_attributes(:friendship_status => CommunityEngine::FriendshipStatus[:denied])
        flash[:notice] = :the_friendship_was_denied.l
        format.html { redirect_to denied_user_friendships_path(@user) }
      else
        format.html { render :action => "edit" }
      end
    end    
  end

  def accept
    @user = CommunityEngine::User.find(params[:user_id])    
    @friendship = @user.friendships_not_initiated_by_me.find(params[:id])
 
    respond_to do |format|
      if @friendship.update_attributes(:friendship_status => CommunityEngine::FriendshipStatus[:accepted]) && @friendship.reverse.update_attributes(:friendship_status => CommunityEngine::FriendshipStatus[:accepted])
        flash[:notice] = :the_friendship_was_accepted.l
        format.html { 
          redirect_to accepted_user_friendships_path(@user) 
        }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def denied
    @user = CommunityEngine::User.find(params[:user_id])    
    @friendships = @user.friendships.where("friendship_status_id = ?", CommunityEngine::FriendshipStatus[:denied].id).page(params[:page])
    
    respond_to do |format|
      format.html
    end
  end


  def accepted
    @user = CommunityEngine::User.find(params[:user_id])    
    @friend_count = @user.accepted_friendships.count
    @pending_friendships_count = @user.pending_friendships.count
          
    @friendships = @user.friendships.accepted.page(params[:page]).per(12)
    
    respond_to do |format|
      format.html
    end
  end
  
  def pending
    @user = CommunityEngine::User.find(params[:user_id])    
    @friendships = @user.friendships.find(:all, :conditions => ["initiator = ? AND friendship_status_id = ?", false, CommunityEngine::FriendshipStatus[:pending].id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @friendship = CommunityEngine::Friendship.find(params[:id])
    @user = @friendship.user
    
    respond_to do |format|
      format.html
    end
  end
  

  def create
    @user = CommunityEngine::User.find(params[:user_id])
    @friendship = CommunityEngine::Friendship.new(:user_id => params[:user_id], :friend_id => params[:friend_id], :initiator => true )
    @friendship.friendship_status_id = CommunityEngine::FriendshipStatus[:pending].id    
    reverse_friendship = CommunityEngine::Friendship.new(params[:friendship])
    reverse_friendship.friendship_status_id = CommunityEngine::FriendshipStatus[:pending].id 
    reverse_friendship.user_id, reverse_friendship.friend_id = @friendship.friend_id, @friendship.user_id
    
    respond_to do |format|
      if @friendship.save && reverse_friendship.save
        CommunityEngine::UserNotifier.friendship_request(@friendship).deliver if @friendship.friend.notify_friend_requests?
        format.html {
          flash[:notice] = :friendship_requested.l_with_args(:friend => @friendship.friend.login) 
          redirect_to accepted_user_friendships_path(@user)
        }
        format.js { render( :inline => :requested_friendship_with.l+" #{@friendship.friend.login}." ) }        
      else
        flash.now[:error] = :friendship_could_not_be_created.l
        format.html { redirect_to user_friendships_path(@user) }
        format.js { render( :inline => "Friendship request failed." ) }                
      end
    end
  end
    
  def destroy
    @user = CommunityEngine::User.find(params[:user_id])    
    @friendship = CommunityEngine::Friendship.find(params[:id])
    CommunityEngine::Friendship.transaction do 
      @friendship.destroy
      @friendship.reverse.destroy
    end
    respond_to do |format|
      format.html { redirect_to accepted_user_friendships_path(@user) }
    end
  end
  
end
end