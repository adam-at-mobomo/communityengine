require CommunityEngine::Engine.config.root.join('lib', 'resource_feeder', 'resource_feeder')
ActionController::Base.send(:include, ResourceFeeder::Rss, ResourceFeeder::Atom)
