module HomeHelper
  
  def newest_pictures limit = 12
    Photo.find(:all, :order => 'created_at desc', :limit => limit)
  end
  
  def recent_comments limit = 10
    Comment.find(:all, :order => 'created_at desc', :limit => limit, :conditions => "commentable_type='User'")
  end
  
  def new_members(limit = 12)
    User.find(:all, :limit => limit, :order => 'created_at DESC')
  end
  
end
