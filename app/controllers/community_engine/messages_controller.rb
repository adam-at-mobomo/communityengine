module CommunityEngine
class MessagesController < BaseController
  before_filter :find_user, :except => [:auto_complete_for_username]
  before_filter :login_required
  before_filter :require_ownership_or_moderator, :except => [:auto_complete_for_username]

  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_username]
  
  def auto_complete_for_username
    @users = CommunityEngine::User.all(:conditions => [ 'LOWER(login) LIKE ?', '%' + (params[:message][:to]) + '%' ])
    render :inline => "<%= auto_complete_result(@users, 'login') %>"
  end
    
  def index
    if params[:mailbox] == "sent"
      @messages = @user.sent_messages.page(params[:page]).per(20)
    else
      @messages = @user.message_threads_as_recipient.order('updated_at DESC').page(params[:page]).per(20)
    end
  end
  
  def show
    @message = CommunityEngine::Message.read(params[:id], current_user)
    @message_thread = CommunityEngine::MessageThread.for(@message, (admin? ? @message.recipient : current_user ))
    @reply = CommunityEngine::Message.new_reply(@user, @message_thread, params)    
  end
  
  def new
    if params[:reply_to]
      in_reply_to = CommunityEngine::Message.find_by_id(params[:reply_to])
      message_thread = CommunityEngine::MessageThread.for(in_reply_to, current_user)
    end
    @message = CommunityEngine::Message.new_reply(@user, message_thread, params)    
  end
  
  def create
    messages = []

    if params[:message][:to].blank?
      # If 'to' field is empty, call validations to catch other errors
      @message = CommunityEngine::Message.new(params[:message])        
      @message.valid?
      render :action => :new and return
    else
      @message = CommunityEngine::Message.new(params[:message])          
      @message.recipient = CommunityEngine::User.find_by_login(params[:message][:to].strip)
      @message.sender = @user
      unless @message.valid?
        render :action => :new and return        
      else
        @message.save!
      end
      flash[:notice] = :message_sent.l
      redirect_to user_messages_path(@user) and return
    end
  end

  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = CommunityEngine::Message.first(:conditions => ["community_engine_messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @user, @user])
          @message.mark_deleted(@user) unless @message.nil?
        }
        flash[:notice] = :messages_deleted.l
      end
      redirect_to user_messages_path(@user)
    end
  end
  
  def delete_message_threads
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          message_thread = CommunityEngine::MessageThread.find_by_id_and_recipient_id(id, @user.id)
          message_thread.destroy if message_thread
        }
        flash[:notice] = :messages_deleted.l
      end
      redirect_to user_messages_path(@user)
    end

  end
  
  private
    def find_user
      @user = CommunityEngine::User.find(params[:user_id])
    end

    def require_ownership_or_moderator
      unless admin? || moderator? || (@user && (@user.eql?(current_user)))
        redirect_to :controller => 'community_engine/sessions', :action => 'new' and return false
      end
      return @user
    end    
end
end