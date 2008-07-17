# == Schema Information
# Schema version: 20080717230806
#
# Table name: groups
#
#  id          :integer(11)   not null, primary key
#  title       :string(255)   
#  description :text          
#  state       :string(255)   
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Group < ActiveRecord::Base
    
    acts_as_taggable_on :tags
    acts_as_state_machine :initial => :approved

    has_many :memberships, :dependent => :destroy
    has_many :membership_requests, :dependent => :destroy
    has_many :users, :through => :memberships, :order => 'last_name, first_name'
    belongs_to :creator, :class_name => 'User', :conditions => "creator = 1", :foreign_key => 'user_id'
    has_many :managers, :through => :memberships, :conditions => "manager = 1", :foreign_key => 'user_id'

    state :approved, :after => :notify_approve 
    state :banned, :after => :notify_ban
        
    event :approve do 
        transitions :to => :approved, :from => :banned  
    end 
    event :ban do 
        transitions :to => :banned, :from => :approved 
    end

    def notify_approve
    end
    
    def notify_ban
    end
    
end
