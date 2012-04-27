module CommunityEngine
class Poll < ActiveRecord::Base
  has_many :choices, :class_name => 'CommunityEngine::Choice', :dependent => :destroy
  validates_presence_of :question
  validates_presence_of :post
  has_many :votes, :class_name => 'CommunityEngine::Vote', :dependent => :destroy
  belongs_to :post, :class_name => 'CommunityEngine::Post'
      
  def voted?(user)
    !self.votes.find_by_user_id(user.id).nil?
  end
  
  def add_choices(choices)
    choices.each do |description|
      choice = self.choices.new(:description => description)
      choice.save
    end
  end

  def self.find_recent(options = {})
    options.reverse_merge! :limit => 5
    find(:all, :order => "community_engine_polls.created_at desc", :limit => options[:limit], :include => [:post => :user])
  end

  def self.find_popular(options = {})
    options.reverse_merge! :limit => 5, :since => 10.days.ago
    
    find(:all, :order => "community_engine_polls.votes_count desc", 
      :limit => options[:limit], 
      :include => [:post => :user],
      :conditions => ["community_engine_polls.created_at > ?", options[:since]]
    )
  end

  def self.find_popular_in_category(category, options = {})
    options.reverse_merge! :limit => 5
    self.includes(:post).order('community_engine_polls.votes_count desc').limit(options[:limit]).where('community_engine_posts.category_id = ?', category.id)
  end

end
end