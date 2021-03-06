require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTest < ActionController::IntegrationTest
  fixtures :all
  include Caboose::SpiderIntegrator

  def test_spider_non_user
    puts ''
    puts 'test_spider_non_user'
    get "/"
    assert_response 200
  
    spider(@response.body, '/', false)
  end
  
  
  def test_spider_aa_user
    puts ''
    puts 'test_spider_user'
    get "/login"
    assert_response :success
    post "/login", :user=>{:login => users(:quentin).login, :password => 'test'}
    assert_response :redirect
    assert session[:user]
    assert_redirected_to :controller=>'profiles', :action=>'show', :id=>users(:quentin).profile.to_param
    follow_redirect!
  
    #   puts @response.body
    spider(@response.body, "/", false)
  end

  
  
  def test_spider_admin
    puts ''
    puts 'test_spider_admin'
    get "/login"
    assert_response :success
    post "/login", :user=>{:login => users(:admin).login, :password => 'test'}
    assert_response :redirect
    assert session[:user]
    assert_redirected_to :controller=>'profiles', :action=>'show', :id=>users(:admin).profile.to_param
    follow_redirect!
  
    #   puts @response.body
    spider(@response.body, "/", false)
  end


end
