# == Schema Information
# Schema version: 20080715224909
#
# Table name: groups
#
#  id         :integer(11)   not null, primary key
#  created_at :datetime      
#  updated_at :datetime      
#

class Group < ActiveRecord::Base
    
    acts_as_taggable_on :tags
    acts_as_state_machine :initial => :approved

    has_many :membership_requests, :dependent => :destroy
    
    has_many :members, :through => :memberships, 
                       :dependent => :destroy,
                       :order => 'last_name, first_name', 
                       :source => :user,
                       :conditions => "role_id = nil"
    #   TODO change membership back to just have the role embedded - creator, manager, member then add the correct conditions here ie:
     #  :conditions => "role = 'member'"
                       
    belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'   
    
    has_many :manager_roles, :through => :memberships, :source => :role, :class_name => 'Role', :conditions => "role_name = 'manager'"
    
    has_many :managers, :through => :manager_roles, :source => :user

    state :approved, :after => :notify_approve 
    state :banned, :after => :notify_ban
        
    event :approve do 
        transitions :to => :approved, :from => :banned  
    end 
    event :ban do 
        transitions :to => :banned, :from => :approved 
    end

    validates_presence_of :name, :description

    def notify_approve
    end
    
    def notify_ban
    end
    
end
