module CommunityEngine
class Category < ActiveRecord::Base
  extend FriendlyId
  has_many :posts, :class_name => 'CommunityEngine::Post', :order => "published_at desc"
  validates_presence_of :name
  
  friendly_id :name, :use => :slugged
      
  def display_new_post_text
    new_post_text
  end
  
end
end