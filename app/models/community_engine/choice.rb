module CommunityEngine
class Choice < ActiveRecord::Base
  belongs_to :poll, :class_name => 'CommunityEngine::Poll'
  validates_presence_of :poll
  validates_presence_of :description
  has_many :votes, :class_name => 'CommunityEngine::Vote', :dependent => :destroy
  
  def votes_percentage(precision = 1)
    total_votes = poll.votes.count    
    percentage = total_votes.eql?(0) ? 0 : ((votes.count.to_f/total_votes.to_f)*100)
    "%01.#{precision}f" % percentage
  end
  
end
end