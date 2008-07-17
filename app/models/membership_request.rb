# == Schema Information
# Schema version: 20080717230806
#
# Table name: membership_requests
#
#  id         :integer(11)   not null, primary key
#  group_id   :integer(11)   
#  user_id    :integer(11)   
#  created_at :datetime      
#  updated_at :datetime      
#

class MembershipRequest < ActiveRecord::Base
    belongs_to :user
    belongs_to :group
end
