require CommunityEngine::Engine.config.root.join('lib', 'auto_complete', 'auto_complete')
require CommunityEngine::Engine.config.root.join('lib', 'auto_complete', 'auto_complete_macros_helper')
ActionController::Base.send :include, AutoComplete
ActionController::Base.helper AutoCompleteMacrosHelper