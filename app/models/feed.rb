# == Schema Information
# Schema version: 20080717230806
#
# Table name: feeds
#
#  id           :integer(11)   not null, primary key
#  user_id      :integer(11)   
#  feed_item_id :integer(11)   
#

class Feed < ActiveRecord::Base
  belongs_to :feed_item
  belongs_to :user
end
