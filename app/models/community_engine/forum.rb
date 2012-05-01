module CommunityEngine
class Forum < ActiveRecord::Base
  acts_as_taggable
  acts_as_list

  validates_presence_of :name

  has_many :moderatorships, :class_name => 'CommunityEngine::Moderatorship', :dependent => :destroy
  has_many :moderators, :through => :moderatorships, :source => :user

  has_many :topics, :class_name => 'CommunityEngine::Topic', :dependent => :destroy

  has_many :sb_posts, :class_name => 'CommunityEngine::SbPost'

  belongs_to :owner, :polymorphic => true

  format_attribute :description
  
  def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end
  
end
end