require File.dirname(__FILE__) + '/../test_helper'

context "PasswordsController -- Test not logged in" do
    
    use_controller PasswordsController
    
    it "Should get the new page" do
        get :new
        assert_response :success
    end

    it "Should reset password" do
        post :create, :email => users(:quentin).email
        assert_equal flash[:notice], "A password reset link has been sent to your email address."
        assert_redirected_to login_path
    end
    
    it "Should not reset password" do        
        post :create, :email => 'bogus@example.com'
        flash[:notice] = "Could not find a user with that email address."
        assert_response :success
    end
    
    it "Should provide edit view" do
        get :edit, :id => roles(:admin).id
        assert_redirected_to new_user_path
    end

    it "Should not update password" do
        put :update
        assert_response :success
    end

    it "Should not update password" do
        put :update, :id => roles(:admin).id
        assert_equal flash[:notice], "Password field cannot be blank."
        assert_response :success
    end
    
    it "Should update password" do
        put :update, :id => roles(:admin).id, :password => 'test'
        assert_redirected_to new_user_path
    end
    
end

context "PasswordsController -- Test logged in" do
    
    use_controller PasswordsController
    
    setup do
        login_as :quentin
    end
    
    it "Should get the new page" do
        get :new
        assert_response 302
    end

    it "Should provide the new interface. No redirect required." do
        get :edit
        assert_response :success
    end
    
    it "Should provide edit view" do
        get :edit, :id => roles(:admin).id
        assert_redirected_to new_user_path
    end

    it "Should update role" do
        put :update, :id => roles(:admin).id, :password => '', :user_id => users(:quentin)
        assert_equal flash[:notice], "Password field cannot be blank."
        assert_response :success
    end
    
end