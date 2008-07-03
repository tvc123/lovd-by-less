require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < Test::Unit::TestCase

    fixtures :users

    def setup
        @controller = UsersController.new
        @request    = ActionController::TestRequest.new
        @response   = ActionController::TestResponse.new
        @user = User.find(:first)
    end

    # should_be_restful do |resource|
    #         
    #         resource.actions    = [:index, :show, :new, :edit, :update, :create, :destroy]
    #         resource.formats    = [:html]
    #         
    #         resource.create.redirect  = "welcome_user_path(@user)" 
    #         resource.update.redirect  = "user_url(@user)" 
    #         resource.destroy.redirect = "users_url"
    #         
    #         resource.denied.actions  = [:edit, :update, :destroy]
    #         resource.denied.redirect = "new_session_url" 
    #         resource.denied.flash    = /permission/i
    #             
    #         resource.create.params = { :login => 'quire', 
    #                                    :email => 'quire@example.com', 
    #                                    :password => 'quire', 
    #                                    :password_confirmation => 'quire', 
    #                                    :newsletter => true, 
    #                                    :notify_of_events => true, 
    #                                    :terms_of_service => true}
    #         resource.update.params = { :email => "Changed@example.com" }
    #     end

    context "on POST to :create -- Allow signup. " do
        setup { create_user }                                
        should_redirect_to "welcome_user_path(@user)" 
        should_set_the_flash_to(/Thanks for signing up! Please check your email to activate your account and then login/i)
    end

    context "on POST to :create -- require login on signup. " do
        setup { create_user :login => '' }
        should_respond_with :success
        should_render_template :new
        should "assign an error to the login field" do
            assert assigns(:user).errors.on(:login) 
        end                                       
    end
    
    context "on POST to :create -- require password on signup. " do
        setup { create_user :password => nil }
        should_respond_with :success
        should_render_template :new
        should "assign an error to the password field" do
            assert assigns(:user).errors.on(:password) 
        end                                       
    end
    
    context "on POST to :create -- require password confirmation on signup. " do
        setup { create_user :password_confirmation => nil }
        should_respond_with :success
        should_render_template :new
        should "assign an error to the password confirmation field" do
            assert assigns(:user).errors.on(:password_confirmation) 
        end                                       
    end
    
    context "on POST to :create -- require email on signup. " do
        setup { create_user :email => nil }
        should_respond_with :success
        should_render_template :new
        should "assign an error to the email field" do
            assert assigns(:user).errors.on(:email) 
        end                                       
    end
    
    context "on GET to :help" do
        setup { get :help, :id => users(:quentin).login }
        should_respond_with :success
        should_render_template :help
    end

    context "on GET to :welcome" do
        setup { get :welcome, :id => users(:quentin).login }
        should_respond_with :success
        should_render_template :welcome
    end

    context "on GET to new (signup)" do
        setup do
            @quentin = users(:quentin)
            login_as :quentin 
            get :new
        end
        should_redirect_to "user_url(@quentin)"
    end

    context "on GET to edit (preferences) not logged in" do
        setup do
            get :edit, :id => users(:quentin)
        end
        should_redirect_to "login_url"
    end
        
    context "on GET to edit (preferences) logged in" do
        setup do
            login_as :quentin
            get :edit, :id => users(:quentin).login
        end
        should_respond_with :success
        should_render_template :edit
    end
    
    context "on GET to edit (preferences) logged in but wrong user" do
        setup do
            @quentin = users(:quentin)
            login_as :quentin
            get :edit, :id => users(:aaron).login
        end
        should_redirect_to "user_url(@quentin)"
    end
    
    def create_user(options = {})
        post :create, 
             :user => { :login => 'quire', 
                        :email => 'quire@example.com', 
                        :password => 'quire', 
                        :password_confirmation => 'quire', 
                        :language_ids => [1,2,3],
                        :grade_level_experience_ids => [1,2,3],
                        :terms_of_service => true }.merge(options)
    end
end