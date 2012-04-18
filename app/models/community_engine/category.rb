module CommunityEngine
class Category < ActiveRecord::Base
  extend FriendlyId
  has_many :posts, :order => "published_at desc"
  validates_presence_of :name
  
  friendly_id :name, :use_slug => true
      
  def display_new_post_text
    new_post_text
  end
  
end
end