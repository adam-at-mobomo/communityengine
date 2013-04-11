require CommunityEngine::Engine.config.root.join('lib', 'acts_as_publishable', 'acts_as_publishable')
ActiveRecord::Base.send(:include, Acts::As::Publishable)

