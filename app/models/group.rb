# == Schema Information
# Schema version: 20080717230806
#
# Table name: groups
#
#  id          :integer(11)   not null, primary key
#  creator_id  :integer(11)   
#  name        :string(255)   
#  description :text          
#  icon        :string(255)   
#  state       :string(255)   
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Group < ActiveRecord::Base
    
    acts_as_taggable_on :tags
    acts_as_state_machine :initial => :approved

    has_many :membership_requests, :dependent => :destroy
    
    belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'   
    
    has_many :memberships
    has_many :members, :through => :memberships, 
                       :dependent => :destroy,
                       :order => 'last_name, first_name', 
                       :source => :user do
        def in_role(role)
            find :all, :conditions => ['role = ?' , role]
        end
    end
                       
    state :approved, :after => :notify_approve 
    state :banned, :after => :notify_ban
        
    event :approve do 
        transitions :to => :approved, :from => :banned  
    end
     
    event :ban do 
        transitions :to => :banned, :from => :approved 
    end

    validates_presence_of :name, :description

    file_column :icon, :magick => {
        :versions => { 
            :bigger => {:crop => "1:1", :size => "200x200", :name => "bigger"},
            :big => {:crop => "1:1", :size => "150x150", :name => "big"},
            :medium => {:crop => "1:1", :size => "100x100", :name => "medium"},
            :small => {:crop => "1:1", :size => "50x50", :name => "small"}
        }
    }
    
    def notify_approve
    end
    
    def notify_ban
    end
    
end
