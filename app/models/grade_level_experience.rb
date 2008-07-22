# == Schema Information
# Schema version: 20080715224909
#
# Table name: grade_level_experiences
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class  GradeLevelExperience < ActiveRecord::Base
  has_and_belongs_to_many :users
end
