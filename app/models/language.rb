# == Schema Information
# Schema version: 20080703173050
#
# Table name: languages
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  english_name :string(255)   
#  is_default   :integer(11)   default(0)
#

class Language < ActiveRecord::Base
  has_and_belongs_to_many :users
end
