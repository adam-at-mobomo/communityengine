module CommunityEngine
  module UserMethods
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end
    
    module ClassMethods
    #named scopes
      def recent
        order("#{table_name}.created_at DESC")
      end
      
      def featured
        where(:featured_writer => true)
      end
      
      def active
        where("#{table_name}.activated_at IS NOT NULL")
      end
      
      def vendors
        where(:vendor => true)
      end
    
      ## Class Methods
    
      def find_by_login_or_email(string)
        where("email = ? OR login = ?", string, string).first
      end
    
      def find_country_and_state_from_search_params(search)
        country     = CommunityEngine::Country.find(search['country_id']) if !search['country_id'].blank?
        state       = CommunityEngine::State.find(search['state_id']) if !search['state_id'].blank?
        metro_area  = CommunityEngine::MetroArea.find(search['metro_area_id']) if !search['metro_area_id'].blank?
    
        if metro_area && metro_area.country
          country ||= metro_area.country 
          state   ||= metro_area.state
          search['country_id'] = metro_area.country.id if metro_area.country
          search['state_id'] = metro_area.state.id if metro_area.state      
        end
        
        states  = country ? country.states.sort_by{|s| s.name} : []
        if states.any?
          metro_areas = state ? state.metro_areas.all(:order => "name") : []
        else
          metro_areas = country ? country.metro_areas : []
        end    
        
        return [metro_areas, states]
      end
    
      def prepare_params_for_search(params)
        search = {}.merge(params)
        search['metro_area_id'] = params[:metro_area_id] || nil
        search['state_id'] = params[:state_id] || nil
        search['country_id'] = params[:country_id] || nil
        search
      end
      
      def build_conditions_for_search(search)
        user = CommunityEngine.user_class.arel_table
        users = CommunityEngine.user_class.active
        if search['country_id'] && !(search['metro_area_id'] || search['state_id'])
          users = users.where(user[:country_id].eq(search['country_id']))
        end
        if search['state_id'] && !search['metro_area_id']
          users = users.where(user[:state_id].eq(search['state_id']))
        end
        if search['metro_area_id']
          users = users.where(user[:metro_area_id].eq(search['metro_area_id']))
        end
        if search['login']    
          users = users.where("`#{table_name}`.login LIKE ?", "%#{search['login']}%")
        end
        if search['vendor']
          users = users.where(user[:vendor].eq(true))
        end    
        if search['description']
          users = users.where("`#{table_name}`.description LIKE ?", "%#{search['description']}%")
        end    
        users
      end  
      
      def find_by_activity(options = {})
        options.reverse_merge! :limit => 30, :require_avatar => true, :since => 7.days.ago   
    
        activities = Activity.since(options[:since]).find(:all, 
          :select => 'activities.user_id, count(*) as count', 
          :group => 'activities.user_id', 
          :conditions => "#{options[:require_avatar] ? ' #{table_name}.avatar_id IS NOT NULL AND ' : ''} #{table_name}.activated_at IS NOT NULL", 
          :order => 'count DESC', 
          :joins => "LEFT JOIN #{table_name} ON #{table_name}.id = activities.user_id",
          :limit => options[:limit]
          )
        activities.map{|a| find(a.user_id) }
      end  
        
      def find_featured
        featured
      end
      
      def search_conditions_with_metros_and_states(params)
        search = prepare_params_for_search(params)
    
        metro_areas, states = find_country_and_state_from_search_params(search)
        
        users = build_conditions_for_search(search)
        return users, search, metro_areas, states
      end  
    
      
      def recent_activity(options = {})
        options.reverse_merge! :per_page => 10, :page => 1
        Activity.recent.joins("LEFT JOIN #{table_name} ON #{table_name}.id = activities.user_id").where("#{table_name}.activated_at IS NOT NULL").select('activities.*').page(options[:page]).per(options[:per_page])
      end
    
      def currently_online
        CommunityEngine.user_class.find(:all, :conditions => ["sb_last_seen_at > ?", Time.now.utc-5.minutes])
      end
      
      def search(query, options = {})
        with_scope :find => { :conditions => build_search_conditions(query) } do
          find :all, options
        end
      end
      
      def build_search_conditions(query)
        query
      end  
    end
    ## End Class Methods  
    
    
    ## Instance Methods
    module InstanceMethods
      def moderator_of?(forum)
        moderatorships.count(:all, :conditions => ['forum_id = ?', (forum.is_a?(CommunityEngine::Forum) ? forum.id : forum)]) == 1
      end
      
      def monitoring_topic?(topic)
        monitored_topics.find_by_id(topic.id)
      end
    
      def recount_metro_area_users
        return unless self.metro_area
        ma = self.metro_area
        ma.users_count = CommunityEngine.use_class.count(:conditions => ["metro_area_id = ?", ma.id])
        ma.save
      end  
        
      def this_months_posts
        self.posts.find(:all, :conditions => ["published_at > ?", DateTime.now.to_time.at_beginning_of_month])
      end
      
      def last_months_posts
        self.posts.find(:all, :conditions => ["published_at > ? and published_at < ?", DateTime.now.to_time.at_beginning_of_month.months_ago(1), DateTime.now.to_time.at_beginning_of_month])
      end
      
      def avatar_photo_url(size = :original)
        if avatar
          avatar.photo.url(size)
        elsif facebook?
          facebook_authorization.picture_url      
        elsif twitter?
          twitter_authorization.picture_url
        else
          case size
            when :thumb
              configatron.photo.missing_thumb.to_s
            else
              configatron.photo.missing_medium.to_s
          end
        end
      end
    
      def deactivate
        return if admin? #don't allow admin deactivation
        CommunityEngine.user_class.transaction do
          update_attribute(:activated_at, nil)
          unless CommunityEngine.custom_user_class?
            update_attribute(:activation_code, make_activation_code)
          end
        end
      end
    
      def activate
        CommunityEngine.user_class.transaction do
          update_attribute(:activated_at, Time.now.utc)
          unless CommunityEngine.custom_user_class?
            update_attribute(:activation_code, nil)
          end
        end
        CommunityEngine::UserNotifier.activation(self).deliver    
      end
      
      def active?
        activation_code.nil? && !activated_at.nil?
      end
      
      def valid_invite_code?(code)
        code == invite_code
      end
      
      def invite_code
        Digest::SHA1.hexdigest("#{self.id}--#{self.email}--#{self.password_salt}")
      end
      
      def location
        metro_area && metro_area.name || ""
      end
      
      def full_location
        "#{metro_area.name if self.metro_area}#{" , #{self.country.name}" if self.country}"
      end
      
      def owner
        self
      end
    
      def staff?
        featured_writer?
      end
      
      def can_request_friendship_with(user)
        !self.eql?(user) && !self.friendship_exists_with?(user)
      end
    
      def friendship_exists_with?(friend)
        CommunityEngine::Friendship.first(:conditions => ["user_id = ? AND friend_id = ?", self.id, friend.id])
      end
        
      def deliver_signup_notification
        CommunityEngine::UserNotifier.signup_notification(self).deliver    
      end
    
      def update_last_login
        self.track_activity(:logged_in) if self.active? && self.last_login_at.nil? || (self.last_login_at && self.last_login_at < Time.now.beginning_of_day)
        self.update_attribute(:last_login_at, Time.now)
      end
      
      def has_reached_daily_friend_request_limit?
        friendships_initiated_by_me.count(:conditions => ['created_at > ?', Time.now.beginning_of_day]) >= CommunityEngine::Friendship.daily_request_limit
      end
    
      def network_activity(page = {}, since = 1.week.ago)
        page.reverse_merge! :per_page => 10, :page => 1
        friend_ids = self.friends_ids
        metro_area_people_ids = self.metro_area ? self.metro_area.users.map(&:id) : []
        
        ids = ((friends_ids | metro_area_people_ids) - [self.id])[0..100] #don't pull TOO much activity for now
        
        Activity.recent.since(since).by_users(ids).page(page[:page]).per(page[:per_page])          
      end
    
      def comments_activity(page = {}, since = 1.week.ago)
        page.reverse_merge :per_page => 10, :page => 1
    
        Activity.recent.since(since).where('community_engine_comments.recipient_id = ? AND activities.user_id != ?', self.id, self.id).joins("LEFT JOIN community_engine_comments ON community_engine_comments.id = activities.item_id AND activities.item_type = 'CommunityEngine::Comment'").page(page[:per_page]).per(page[:page])
      end
    
      def friends_ids
        return [] if accepted_friendships.empty?
        accepted_friendships.map{|fr| fr.friend_id }
      end
      
      def recommended_posts(since = 1.week.ago)
        return [] if tags.empty?
        rec_posts = CommnityEngine::Post.tagged_with(tags.map(&:name), :any => true).where(['community_engine_posts.user_id != ? AND published_at > ?', self.id, since ])
        rec_posts = rec_posts.order('published_at DESC').limit(10)
        rec_posts
      end
      
      def display_name
        login
      end
      
      def admin?
        role && role.eql?(CommunityEngine::Role[:admin])
      end
    
      def moderator?
        role && role.eql?(CommunityEngine::Role[:moderator])
      end
    
      def member?
        role && role.eql?(CommunityEngine::Role[:member])
      end
      
      def male?
        gender && gender.eql?(MALE)
      end
      
      def female
        gender && gender.eql?(FEMALE)    
      end
    
      def update_last_seen_at
        CommunityEngine.user_class.update_all ['sb_last_seen_at = ?', Time.now.utc], ['id = ?', self.id]
        self.sb_last_seen_at = Time.now.utc
      end
      
      def unread_messages?
        unread_message_count > 0 ? true : false
      end
      
      def unread_message_count
        message_threads_as_recipient.count(:conditions => ["community_engine_messages.recipient_id = ? AND community_engine_messages.recipient_deleted = ? AND read_at IS NULL", self.id, false], :include => :message)
      end
      
      def valid_birthday
        date = configatron.min_age.years.ago
        errors.add(:birthday, "must be before #{date.strftime("%Y-%m-%d")}") unless birthday && (birthday.to_date <= date.to_date)    
      end
      
      def check_spam
        if !configatron.akismet_key.nil? && self.spam?
          self.errors.add(:base, :user_spam_error.l) 
        end
      end  
      
      ## End Instance Methods
    
      protected
  
      # before filters
      def whitelist_attributes
        if self.login.blank?
          self.login = (self.name || "").gsub(/[^A-Za-z0-9\- ]+/, ' ').downcase.split.join("-")
          self.login = "none" if self.login.blank?
          while CommunityEngine.user_class.where(:login => self.login).where("id <> ?", self.id).count > 0 do
            self.login = "#{self.login.gsub(/[0-9]$/, '')}#{rand(10000)}"
          end
        end
        self.login = self.login.strip
        self.description = white_list(self.description )
        self.stylesheet = white_list(self.stylesheet )
      end
    end
  end
end