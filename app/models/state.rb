# == Schema Information
# Schema version: 20080715224909
#
# Table name: states
#
#  id           :integer(11)   not null, primary key
#  name         :string(128)   default(""), not null
#  abbreviation :string(3)     default(""), not null
#  country_id   :integer(16)   not null
#

class State < ActiveRecord::Base
    has_many :users
end
