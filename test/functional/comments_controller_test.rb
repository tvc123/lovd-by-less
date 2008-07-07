require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  
  context 'on GET to :index' do
    should "render action when logged in as :owner and viewing :user" do
      p = users(:aaron)
      get :index, {:profile_id => p.id}, {:user => users(:quentin).id}
      assert_not_nil assigns(:comments)
      assert !assigns(:comments).empty?
      assert_response :success
      assert_template 'index'
      assert_tag :tag => 'a', :content => '&larr; Back to Profile', :attributes => {:href => profile_path(p)}
    end
    
    should "redirect to home_path when not logged" do
      p = users(:aaron)
      get :index, {:profile_id => p.id}
      assert_response :redirect
      assert_redirected_to login_path
    end
  end
  
  context 'on POST to :create' do
    should "render action when logged in as :owner on blog" do
      p = users(:quentin)
      b = p.blogs.first
      assert_difference "Comment.count" do
        post :create, {:profile_id => p.id, :blog_id => b.id, :format => 'js', :comment => {:comment => 'test'}}, {:user => p.id}
      end
    end
    
    should "render action when logged in as :user on blog" do
      p = users(:quentin)
      b = p.blogs.first
      assert_difference "Comment.count" do
        post :create, {:profile_id => p.id, :blog_id => b.id, :format => 'js', :comment => {:comment => 'test'}}, {:user => users(:aaron).id}
      end
    end
    
    should "render action with bad data when logged in as :user on blog" do
      p = users(:quentin)
      b = p.blogs.first
      assert_no_difference "Comment.count" do
        post :create, {:profile_id => p.id, :blog_id => b.id, :format => 'js', :comment => {:comment => ''}}, {:user => users(:aaron).id}
      end
    end
  end
end
