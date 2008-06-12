class Blog < ActiveRecord::Base
  has_many :comments, :as => :commentable, :order => "created_at asc"
  belongs_to :user
  validates_presence_of :title, :body
  
  def after_create
    feed_item = FeedItem.create(:item => self)
    ([user] + user.friends + user.followers).each{ |u| u.feed_items << feed_item }
  end
  
  
  def to_param
    "#{self.id}-#{title.to_safe_uri}"
  end

end
