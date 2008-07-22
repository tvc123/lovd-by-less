# == Schema Information
# Schema version: 20080717230806
#
# Table name: forum_topics
#
#  id         :integer(11)   not null, primary key
#  title      :string(255)   
#  forum_id   :integer(11)   
#  owner_id   :integer(11)   
#  created_at :datetime      
#  updated_at :datetime      
#

class ForumTopic < ActiveRecord::Base
  validates_presence_of :title, :owner_id, :forum_id
  
  belongs_to :owner, :class_name => "User"
  belongs_to :forum
  
  has_many :posts, :class_name => "ForumPost", :foreign_key => "topic_id", :dependent => :destroy
  
  def to_param
    "#{title.to_safe_uri}"
  end
  
  def after_create
    feed_item = FeedItem.create(:item => self)
  end
  
end
