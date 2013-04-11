# Require all the necessary files to run TinyMCE
require File.join(File.dirname(__FILE__), 'tiny_mce', 'base')
require File.join(File.dirname(__FILE__), 'tiny_mce', 'exceptions')
require File.join(File.dirname(__FILE__), 'tiny_mce', 'configuration')
require File.join(File.dirname(__FILE__), 'tiny_mce', 'spell_checker')
require File.join(File.dirname(__FILE__), 'tiny_mce', 'helpers')

module TinyMCE
  def self.initialize
    return if @intialized
    raise "ActionController is not available yet." unless defined?(ActionController)
    ActionController::Base.send(:include, TinyMCE::Base)
    ActionController::Base.send(:helper, TinyMCE::Helpers)
    @intialized = true
  end
end

TinyMCE.initialize
