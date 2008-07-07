require File.dirname(__FILE__) + '/../test_helper'

class PhotoTest < ActiveSupport::TestCase
  
  context "A Photo instance" do
    
    should_belong_to :user
    should_require_attributes :image, :profile_id
  end
end