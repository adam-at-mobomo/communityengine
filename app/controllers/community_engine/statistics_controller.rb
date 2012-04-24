module CommunityEngine
class StatisticsController < BaseController
  before_filter :login_required
  before_filter :admin_required

  def index
    @total_users = CommunityEngine.user_class.count(:conditions => ['activated_at IS NOT NULL'])
    @unactivated_users = CommunityEngine.user_class.count(:conditions => ['activated_at IS NULL'])

    @yesterday_new_users = find_new_users(1.day.ago.midnight, Date.today.midnight)
    @today_new_users = find_new_users(Date.today.midnight, Date.today.tomorrow.midnight)  

    @active_users_count = Activity.count(:all, :group => "user_id", :conditions => ["created_at > ?", 1.month.ago]).size

    @active_users = CommunityEngine.user_class.find_by_activity({:since => 1.month.ago})
    
    @percent_reporting_zip = (CommunityEngine.user_class.count(:all, :conditions => "zip IS NOT NULL") / @total_users.to_f)*100
    
    users_reporting_gender = CommunityEngine.user_class.count(:all, :conditions => "gender IS NOT NULL")
    @percent_male = (CommunityEngine.user_class.count(:all, :conditions => ['gender = ?', CommunityEngine.user_class::MALE ]) / users_reporting_gender.to_f) * 100
    @percent_female = (CommunityEngine.user_class.count(:all, :conditions => ['gender = ?', CommunityEngine.user_class::FEMALE] ) / users_reporting_gender.to_f) * 100        
    
    @featured_writers = CommunityEngine.user_class.find_featured

    @posts = CommunityEngine::Post.find(:all, :conditions => ["? <= community_engine_posts.published_at AND community_engine_posts.published_at <= ? AND #{CommunityEngine.user_class.table_name}.featured_writer = ?", Time.now.beginning_of_month, (Time.now.end_of_month + 1.day), true], :include => :user)        
  end  

      
  protected
    def find_new_users(from, to, limit= nil)
      CommunityEngine.user_class.active.where(:created_at => from..to)
    end
  

end
end