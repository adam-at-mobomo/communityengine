require 'digest/sha1'

module CommunityEngine
  class User < ActiveRecord::Base
    CommunityEngine.user_class.send :validate, :valid_birthday, :if => :requires_valid_birthday?
    
    acts_as_authentic do |c|
      c.crypto_provider = CommunityEngine::CommunityEngineSha1CryptoMethod
      
      c.validates_length_of_password_field_options = { :within => 6..20, :if => :password_required? }
      c.validates_length_of_password_confirmation_field_options = { :within => 6..20, :if => :password_required? }
  
      c.validates_length_of_login_field_options = { :minimum => 5, :unless => :omniauthed? }
      c.validates_format_of_login_field_options = { :with => /^[\sA-Za-z0-9_-]+$/, :unless => :omniauthed? }
  
      c.validates_length_of_email_field_options = { :within => 3..100, :if => :email_required? }
      c.validates_format_of_email_field_options = { :with => /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/, :if => :email_required? }
    end
    
    def reset_password
       new_password = newpass(8)
       self.password = new_password
       self.password_confirmation = new_password
       return self.valid?
    end
    
    def newpass( len )
       chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
       new_password = ""
       1.upto(len) { |i| new_password << chars[rand(chars.size-1)] }
       return new_password
    end
    
    def deliver_password_reset_instructions!
      reset_perishable_token!
      CommunityEngine::UserNotifier.password_reset_instructions(self).deliver
    end  
        
    def self.find_or_create_from_authorization(auth)
      user = CommunityEngine.user_class.find_or_initialize_by_email(:email => auth.email)
      user.login ||= auth.nickname
      
      if user.new_record?
        new_password = user.newpass(8)
        user.password = new_password
        user.password_confirmation = new_password
      end
      
      user.authorizing_from_omniauth = true
      
      if user.save
        user.activate unless user.active?
        user.reset_persistence_token!
      end
      user    
    end
    
    protected
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def email_required?
      !omniauthed?
    end
    
    def requires_valid_birthday?
      !omniauthed?
    end
    
    def omniauthed?
      authorizing_from_omniauth || authorizations.any?      
    end
  end
end