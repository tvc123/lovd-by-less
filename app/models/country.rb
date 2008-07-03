# == Schema Information
# Schema version: 20080703173050
#
# Table name: countries
#
#  id           :integer(11)   not null, primary key
#  name         :string(128)   default(""), not null
#  abbreviation :string(3)     default(""), not null
#

class Country < ActiveRecord::Base
end
