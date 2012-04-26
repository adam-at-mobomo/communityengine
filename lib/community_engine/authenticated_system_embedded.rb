module AuthenticatedSystemEmbedded
  protected
      
  # Accesses the current user from the session.
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  # Create a user session without credentials.
  def current_user=(user)
    return if current_user # Use act_as_user= to switch to another user account
    @current_user_session = CommunityEngine::UserSession.create(user, true)
    @current_user = @current_user_session.record
  end

  # Set session to another user.  Only available to admins
  def assume_user(new_user)
    return unless current_user && current_user.admin? && !new_user.admin?
    session[:admin_id] = current_user.id
    CommunityEngine::UserSession.create(new_user, true)
  end

  def return_to_admin
    unless current_user && !session[:admin_id].nil? && !current_user.admin?
      redirect_to login_path_helper
      return
    end

    admin = CommunityEngine.user_class.find(session[:admin_id])
    if admin && admin.admin?
      session[:admin_id] = nil
      CommunityEngine::UserSession.create(admin, true)
      redirect_to user_path(admin)
    else
      current_user_session.destroy
      redirect_to login_path_helper
    end
  end

  # Accesses the current session.
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = CommunityEngine::UserSession.find
  end
end