# == Schema Information
# Schema version: 20080717230806
#
# Table name: memberships
#
#  id         :integer(11)   not null, primary key
#  group_id   :integer(11)   
#  user_id    :integer(11)   
#  role_id    :integer(11)   
#  created_at :datetime      
#  updated_at :datetime      
#
class Membership < ActiveRecord::Base
    belongs_to :user
    belongs_to :group
    belongs_to :role
end
