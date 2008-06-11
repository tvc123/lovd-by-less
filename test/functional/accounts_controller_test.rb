require File.dirname(__FILE__) + '/../test_helper'
  
context "AccountsControllerTest -- Not logged in" do

    use_controller AccountsController

    it "should activate user" do
        assert_nil User.authenticate('aaron', 'badtest')
        get :activate, :activation_code => users(:aaron).activation_code
        assert_redirected_to '/login'
        assert_equal users(:quentin), User.authenticate('quentin', 'test')
    end

    it "should not activate user without key" do
        get :activate
        assert_nil flash[:notice]
    end

    it "should not activate user with blank key" do
        get :activate, :activation_code => ''
        assert_nil flash[:notice]
    end

end
