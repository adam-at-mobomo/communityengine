require "community_engine"
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
        CommunityEngine.user_class.send :extend, FriendlyId
        CommunityEngine.user_class.send :include, CommunityEngine::FacebookProfile
        CommunityEngine.user_class.send :include, CommunityEngine::TwitterProfile
        CommunityEngine.user_class.send :include, CommunityEngine::UrlUpload
        CommunityEngine.user_class.send :include, Rakismet::Model
      end
    end
  end
end

