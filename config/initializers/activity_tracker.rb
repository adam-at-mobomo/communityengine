require CommunityEngine::Engine.config.root.join('lib', 'activity_tracker', 'activity_tracker')
ActiveRecord::Base.send(:include, ActivityTracker)
