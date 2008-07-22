# == Schema Information
# Schema version: 20080715224909
#
# Table name: memberships
#
#  id         :integer(11)   not null, primary key
#  group_id   :integer(11)   
#  user_id    :integer(11)   
#  creator    :boolean(1)    
#  manager    :boolean(1)    
#  created_at :datetime      
#  updated_at :datetime      
#

class Membership < ActiveRecord::Base
    belongs_to :user
    belongs_to :group
end
