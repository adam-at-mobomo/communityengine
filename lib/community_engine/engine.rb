require "community_engine"
require 'commuinty_engine/user_methods'
require 'rails/all'

module ::CommunityEngine
  class Engine < Rails::Engine
    isolate_namespace CommunityEngine
    engine_name "community_engine"

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    initializer engine_name do |app|
      require root.join('config','application_config.rb')
      require app.root.join('config','application_config.rb')            
    end
    
    initializer "#{engine_name}.initializers", :before => :load_config_initializers do       
      Dir["#{root}/config/initializers/**/*.rb"].each do |initializer| 
        load(initializer) unless File.exists?("#{root.to_s}/config/initializers/#{File.basename(initializer)}")
      end                
    end
        
    initializer "#{engine_name}.rakismet_config", :before => "rakismet.setup" do |app|
      if !configatron.akismet_key.nil?
        app.config.rakismet.key  = configatron.akismet_key
        app.config.rakismet.url  = configatron.app_host
      end
    end
    
    initializer "#{engine_name}.load_middleware", :after => :load_config_initializers do
      if !configatron.auth_providers.nil?
        configatron.protect(:auth_providers)
        configatron.auth_providers.to_hash.each do |name, hash|
          provider = "::OmniAuth::Strategies::#{name.to_s.classify}".constantize
          config.app_middleware.use provider, hash[:key], hash[:secret]          
        end
      end
    end
    
    config.to_prepare do
      if CommunityEngine.user_class
        CommunityEngine.user_class.send :const_set, 'MALE', 'M'
        CommunityEngine.user_class.send :const_set, 'FEMALE', 'F'

        CommunityEngine.user_class.send :extend, FriendlyId
        CommunityEngine.user_class.send :attr_protected, :admin, :featured, :role_id, :akismet_attrs
        CommunityEngine.user_class.send :friendly_id, :login, :use => :slugged, :slug_column => 'login_slug'

        CommunityEngine.user_class.send :include, CommunityEngine::FacebookProfile
        CommunityEngine.user_class.send :include, CommunityEngine::TwitterProfile
        CommunityEngine.user_class.send :include, CommunityEngine::UrlUpload
        CommunityEngine.user_class.send :include, Rakismet::Model
        CommunityEngine.user_class.send :rakismet_attrs, :author => :login, :comment_type => 'registration', :content => :description, :user_ip => :last_login_ip, :author_email => :email
        
        CommunityEngine.user_class.send :acts_as_taggable  
        CommunityEngine.user_class.send :acts_as_commentable
        CommunityEngine.user_class.send :has_enumerated, :role, :class_name => 'CommunityEngine::Role', :foreign_key => 'role_id'      
        CommunityEngine.user_class.send :tracks_unlinked_activities, [:logged_in, :invited_friends, :updated_profile, :joined_the_site]  
  
  #callbacks  
        CommunityEngine.user_class.send :before_create, :make_activation_code
        CommunityEngine.user_class.send :after_create,  :update_last_login
        CommunityEngine.user_class.send :after_create,  :deliver_signup_notification
        CommunityEngine.user_class.send :before_save,   :whitelist_attributes  
        CommunityEngine.user_class.send :after_save,    :recount_metro_area_users
        CommunityEngine.user_class.send :after_destroy, :recount_metro_area_users
  
  #associations
        CommunityEngine.user_class.send :has_many, :authorizations, :class_name => 'CommunityEngine::Authorization', :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :posts, :class_name => 'CommunityEngine::Post', :order => "published_at desc", :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :photos, :class_name => 'CommunityEngine::Photo', :order => "created_at desc", :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :invitations, :class_name => 'CommunityEngine::Invitation', :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :rsvps, :class_name => 'CommunityEngine::Rsvp', :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :albums, :class_name => 'CommunityEngine::Album', :dependent => :destroy    

    #friendship associations
        CommunityEngine.user_class.send :has_many, :friendships, :class_name => "CommunityEngine::Friendship", :foreign_key => "user_id", :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :accepted_friendships, :class_name => "CommunityEngine::Friendship", :conditions => ['friendship_status_id = ?', 2]
        CommunityEngine.user_class.send :has_many, :pending_friendships, :class_name => "CommunityEngine::Friendship", :conditions => ['initiator = ? AND friendship_status_id = ?', false, 1]
        CommunityEngine.user_class.send :has_many, :friendships_initiated_by_me, :class_name => "CommunityEngine::Friendship", :foreign_key => "user_id", :conditions => ['initiator = ?', true], :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :friendships_not_initiated_by_me, :class_name => "CommunityEngine::Friendship", :foreign_key => "user_id", :conditions => ['initiator = ?', false], :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :occurances_as_friend, :class_name => "CommunityEngine::Friendship", :foreign_key => "friend_id", :dependent => :destroy

    #forums
        CommunityEngine.user_class.send :has_many, :moderatorships, :class_name => 'CommunityEngine::Moderatorship', :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :forums, :class_name => 'CommunityEngine::Forum', :through => :moderatorships, :order => 'community_engine_forums.name'
        CommunityEngine.user_class.send :has_many, :sb_posts, :class_name => 'CommunityEngine::SbPost', :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :topics, :class_name => 'CommunityEngine::Topic', :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :monitorships, :class_name => 'CommunityEngine::Monitorship', :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :monitored_topics, :through => :monitorships, :conditions => ['community_engine_monitorships.active = ?', true], :order => 'community_engine_topics.replied_at desc', :source => :topic

        CommunityEngine.user_class.send :belongs_to,  :avatar, :class_name => "CommunityEngine::Photo", :foreign_key => "avatar_id", :inverse_of => :user_as_avatar
        CommunityEngine.user_class.send :belongs_to,  :metro_area, :class_name => 'CommunityEngine::MetroArea', :counter_cache => true
        CommunityEngine.user_class.send :belongs_to,  :state, :class_name => 'CommunityEngine::State'
        CommunityEngine.user_class.send :belongs_to,  :country, :class_name => 'CommunityEngine::Country'
        CommunityEngine.user_class.send :has_many,    :comments_as_author, :class_name => "CommunityEngine::Comment", :foreign_key => "user_id", :order => "created_at desc", :dependent => :destroy
        CommunityEngine.user_class.send :has_many,    :comments_as_recipient, :class_name => "CommunityEngine::Comment", :foreign_key => "recipient_id", :order => "created_at desc", :dependent => :destroy
        CommunityEngine.user_class.send :has_many,    :clippings, :class_name => 'CommunityEngine::Clipping', :order => "created_at desc", :dependent => :destroy
        CommunityEngine.user_class.send :has_many,    :favorites, :class_name => 'CommunityEngine::Favorite', :order => "created_at desc", :dependent => :destroy
        
        CommunityEngine.user_class.send :accepts_nested_attributes_for, :avatar

  #validation
        CommunityEngine.user_class.send :validates_presence_of,     :metro_area, :if => Proc.new { |user| user.state }
        CommunityEngine.user_class.send :validates_uniqueness_of,   :login
        CommunityEngine.user_class.send :validates_exclusion_of,    :login, :in => configatron.reserved_logins

        CommunityEngine.user_class.send :validate, :valid_birthday, :if => :requires_valid_birthday?
        CommunityEngine.user_class.send :validate, :check_spam    
    
    #messages
        CommunityEngine.user_class.send :has_many, :all_sent_messages, :class_name => "CommunityEngine::Message", :foreign_key => "sender_id", :dependent => :destroy
        CommunityEngine.user_class.send :has_many, :sent_messages,
             :class_name => 'CommunityEngine::Message',
             :foreign_key => 'sender_id',
             :order => "community_engine_messages.created_at DESC",
             :conditions => ["community_engine_messages.sender_deleted = ?", false]

        CommunityEngine.user_class.send :has_many, :received_messages,
             :class_name => 'CommunityEngine::Message',
             :foreign_key => 'recipient_id',
             :order => "community_engine_message.created_at DESC",
             :conditions => ["community_engine_message.recipient_deleted = ?", false]
        CommunityEngine.user_class.send :has_many, :message_threads_as_recipient, :class_name => "CommunityEngine::MessageThread", :foreign_key => "recipient_id"               
  
        CommunityEngine.user_class.send :attr_accessible, :avatar_id, :company_name, :country_id, :description, :email,
    :firstname, :fullname, :gender, :lastname, :login, :metro_area_id,
    :middlename, :notify_comments, :notify_community_news,
    :notify_friend_requests, :password, :password_confirmation,
    :profile_public, :state_id, :stylesheet, :time_zone, :vendor, :zip, :avatar_attributes, :birthday

        CommunityEngine.user_class.send :attr_accessor, :authorizing_from_omniauth
        
        CommunityEngine.user_class.send :include, CommunityEngine::UserMethods
      end
    end
  end
end

