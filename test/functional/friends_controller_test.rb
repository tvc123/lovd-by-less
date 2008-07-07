require File.dirname(__FILE__) + '/../test_helper'

class FriendsControllerTest < ActionController::TestCase

  should 'render index page not logged in' do
    assert_nothing_raised do
      get :index, :profile_id => users(:quentin).id
      assert_response :success
      assert_template 'index'
    end
  end



  should 'render my index page' do
    assert_nothing_raised do
      get :index, {:profile_id => users(:quentin).id}, {:user => users(:quentin).id}
      assert_response :success
      assert_template 'index'
    end
  end



  should "make a fan" do
    Friend.destroy_all

    post :create, {:profile_id=>users(:quentin).id, :id => users(:aaron).id, :format=>'js'}, {:user=>users(:quentin).id}
    assert_response :success

    users(:quentin).reload
    users(:aaron).reload

    assert !users(:quentin).friend_of?(users(:aaron))
    assert users(:quentin).following?(users(:aaron))
    assert users(:aaron).followed_by?(users(:quentin))
  end


  should "make a friendship" do
    Friend.destroy_all
    Friend.make_friends users(:quentin), users(:aaron)
    post :create, {:profile_id=>users(:quentin).id, :id=>users(:aaron).id, :format=>'js'}, {:user=>users(:quentin).id}
    assert_response :success

    users(:quentin).reload
    users(:aaron).reload

    assert users(:quentin).friend_of?(users(:aaron))
    assert !users(:quentin).followed_by?(users(:aaron))
    assert users(:aaron).friend_of?(users(:quentin))
    assert !users(:aaron).followed_by?(users(:quentin))
  end

  should "error while trying to make an invalid friendship" do
    Friend.destroy_all
    post :create, {:profile_id=>users(:quentin).id, :id=>users(:quentin).id, :format=>'js'}, {:user=>users(:quentin).id}
    assert_response :success

    users(:quentin).reload
    users(:aaron).reload
  end

  should 'stop following' do
    Friend.destroy_all
    Friend.make_friends users(:quentin), users(:aaron)
    delete :destroy, {:profile_id=>users(:quentin).id, :id=>users(:aaron).id, :format=>'js'}, {:user=>users(:quentin).id}
    assert_response :success

    users(:quentin).reload
    users(:aaron).reload

    assert !users(:quentin).following?(users(:aaron))
  end

  should 'stop being friends' do
    Friend.destroy_all
    Friend.make_friends users(:quentin), users(:aaron)
    Friend.make_friends users(:aaron), users(:quentin)
    delete :destroy, {:profile_id=>users(:quentin).id, :id=>users(:aaron).id, :format=>'js'}, {:user=>users(:quentin).id}
    assert_response :success

    users(:quentin).reload
    users(:aaron).reload

    assert !users(:quentin).friend_of?(users(:aaron))
    assert !users(:quentin).following?(users(:aaron))
    assert users(:quentin).followed_by?(users(:aaron))
  end
end