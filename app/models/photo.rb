# == Schema Information
# Schema version: 20080717230806
#
# Table name: photos
#
#  id         :integer(11)   not null, primary key
#  caption    :string(1000)  
#  created_at :datetime      
#  updated_at :datetime      
#  user_id    :integer(11)   
#  image      :string(255)   
#


class Photo < ActiveRecord::Base

    has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'

    belongs_to :user

    validates_presence_of :image, :user_id

    def after_create
        feed_item = FeedItem.create(:item => self)
        ([user] + user.friends + user.followers).each{ |u| u.feed_items << feed_item }
    end

    file_column :image, :magick => {
        :versions => { 
            :square => {:crop => "1:1", :size => "50x50", :name => "square"},
            :small => "175x250>"
        }
    }

end
