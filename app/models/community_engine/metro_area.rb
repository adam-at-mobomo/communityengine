module CommunityEngine
class MetroArea < ActiveRecord::Base
  has_many :users, :class_name => CommunityEngine.user_class_name
  belongs_to :state, :class_name => 'CommunityEngine::State'
  belongs_to :country, :class_name => 'CommunityEngine::Country'

  #validates_presence_of :state, :if => Proc.new { |user| user.country.eql?(Country.get(:us)) }
  validates_presence_of :country_id
  validates_presence_of :name

	acts_as_commentable

  def to_s
    name
  end

end
end