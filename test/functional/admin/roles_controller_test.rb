require File.dirname(__FILE__) + '/../../test_helper'

require 'authenticated_test_helper'
context "RolesController -- Not logged in" do
    
    use_controller Admin::RolesController
    
    it "Should redirect to the login page from index page" do
        get :index
        assert_redirected_to "/login"
        assert_equal "You must be logged in to access this feature." , flash[:error]
    end
    
    it "Should redirect from new page" do
        get :new
        assert_redirected_to "/login"
    end
    
    it "Should redirect from create a new role" do
        post :create, :role => { :rolename => 'testrole' }
        assert_redirected_to "/login"
    end

    it "Should redirect from show a role" do
        get :show, :id => roles(:admin).id
        assert_redirected_to "/login"
    end

    it "Should redirect from role edit" do
        get :edit, :id => roles(:admin).id
        assert_redirected_to "/login"
    end

    it "Should redirect from update role" do
        put :update, :id => roles(:admin).id, :role => { :rolename => 'updatedrole' }
        assert_redirected_to "/login"
    end

    it "Should redirect from destroy role" do
        delete :destroy, :id => roles(:admin).id
        assert_redirected_to "/login"
    end
     
end


context "RolesController -- Test logged in" do
    
    use_controller Admin::RolesController
    
    setup do
        login_as :quentin
    end
    
    it "Should get the index page" do
        get :index, :user_id => users(:quentin)
        assert_response :success
    end
    
    it "Should get the new page" do
        get :new
        assert_response :success
    end

    it "Should create a new role" do
        assert_difference('Role.count') do
            post :create, :role => { :rolename => 'testrole' }
        end
         
        assert_redirected_to role_path(assigns(:role))
    end

    it "Should show a role" do
        get :show, :id => roles(:admin).id
        assert_response :success
    end

    it "Should role edit" do
        get :edit, :id => roles(:admin).id
        assert_response :success
    end

    it "Should update role" do
        put :update, :id => roles(:admin).id, :role => { :rolename => 'updatedrole' }, :user_id => users(:quentin)
        assert_redirected_to roles_path()
    end

    it "Should destroy role" do
        assert_difference('Permission.count', -1) do
            delete :destroy, :id => roles(:admin).id, :user_id => users(:quentin)
        end
        assert_redirected_to roles_path
    end
    
end