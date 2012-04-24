module CommunityEngine
class ModeratorsController < BaseController
  before_filter :admin_required
  
  def create
    @forum = CommunityEngine::Forum.find(params[:forum_id])
    @user = CommunityEngine::User.find(params[:user_id])
    @moderatorship = CommunityEngine::Moderatorship.create!(:forum => @forum, :user => @user)
    respond_to do |format|
      format.js
    end

  end

  def destroy
    @moderatorship = CommunityEngine::Moderatorship.find(params[:id])
    @moderatorship.destroy
    respond_to do |format|
      format.js
    end
  end


end
end