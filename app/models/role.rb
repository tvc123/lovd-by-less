# == Schema Information
# Schema version: 20080717230806
#
# Table name: roles
#
#  id         :integer(11)   not null, primary key
#  rolename   :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Role < ActiveRecord::Base
    has_many :permissions
    has_many :users, :through => :permissions
    has_many :memberships
    
    validates_presence_of :rolename
    
end

