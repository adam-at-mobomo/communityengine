require 'digest/sha1'

module CommunityEngine
class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = CommunityEngine::CommunityEngineSha1CryptoMethod
    
    c.validates_length_of_password_field_options = { :within => 6..20, :if => :password_required? }
    c.validates_length_of_password_confirmation_field_options = { :within => 6..20, :if => :password_required? }

    c.validates_length_of_login_field_options = { :minimum => 5, :unless => :omniauthed? }
    c.validates_format_of_login_field_options = { :with => /^[\sA-Za-z0-9_-]+$/, :unless => :omniauthed? }

    c.validates_length_of_email_field_options = { :within => 3..100, :if => :email_required? }
    c.validates_format_of_email_field_options = { :with => /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/, :if => :email_required? }
  end
  
end
end