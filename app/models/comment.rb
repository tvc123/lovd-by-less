# == Schema Information
# Schema version: 1
#
# Table name: comments
#
#  id               :integer(11)   not null, primary key
#  comment          :text          
#  created_at       :datetime      not null
#  updated_at       :datetime      not null
#  profile_id       :integer(11)   
#  commentable_type :string(255)   default(""), not null
#  commentable_id   :integer(11)   not null
#  is_denied        :integer(11)   default(0), not null
#  is_reviewed      :boolean(1)    
#
class Comment < ActiveRecord::Base

    validates_presence_of :comment, :profile

    belongs_to :commentable, :polymorphic => true
    belongs_to :user

    def after_create
        feed_item = FeedItem.create(:item => self)
        ([user] + user.friends + user.followers).each{ |u| u.feed_items << feed_item }
    end

    def self.between_users user1, user2
        find(:all, {
            :order => 'created_at desc',
            :conditions => [
                "(user_id=? and commentable_id=?) or (user_id=? and commentable_id=?) and commentable_type='User'",
                user1.id, user2.id, user2.id, user1.id]
        })
    end

end
