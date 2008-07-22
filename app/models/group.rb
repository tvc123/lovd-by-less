# == Schema Information
# Schema version: 20080717230806
#
# Table name: groups
#
#  id          :integer(11)   not null, primary key
#  creator_id  :integer(11)   
#  name        :string(255)   
#  description :text          
#  state       :string(255)   
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Group < ActiveRecord::Base
    has_many :memberships, :dependent => :destroy
    has_many :membership_requests, :dependent => :destroy
    has_many :users, :through => :memberships, :order => 'last_name, first_name'
    belongs_to :creator, :class_name => 'User', :conditions => "creator = 1", :foreign_key => 'user_id'
    has_many :managers, :through => :memberships, :conditions => "manager = 1", :foreign_key => 'user_id' 
end
