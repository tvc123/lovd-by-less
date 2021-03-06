require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

    load_all_fixtures
    
    context 'A user instance' do
        should_belong_to :user
        should_have_many :friendships
        should_have_many :friends,   :through     => :friendships
        should_have_many :follower_friends
        should_have_many :following_friends
        should_have_many :followers, :through => :follower_friends
        should_have_many :followings, :through => :following_friends
        should_have_many :comments, :blogs
        should_protect_attributes :is_active

        should_require_unique_attributes :login, :email

        should_ensure_length_in_range :password, (4..40)
        should_ensure_length_in_range :login, (3..40)
        should_ensure_length_in_range :email, (0..100)

        should_have_many :permissions
        should_have_many :roles, :through => :permissions

        should_protect_attributes :crypted_password, :salt, :remember_token, :remember_token_expires_at, :activation_code, :activated_at,
                  :password_reset_code, :enabled, :can_send_messages, :is_active, :created_at, :updated_at, :plone_password

        should_ensure_length_in_range :email, 3..100, :short_message => 'does not look like an email address.', :long_message => 'does not look like an email address.'
        should_allow_values_for :email, 'a@x.com', 'de.veloper@example.com', :message => 'does not look like an email address.'
        should_not_allow_values_for :email, 'example.com', '@example.com', 'developer@example', 'developer', :message => 'does not look like an email address.'
    end

    should "Create a new user" do
        assert_difference 'User.count' do
            user = create_user
            assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
        end
    end
 
    should "Create a new user and lowercase the login" do
        assert_difference 'User.count' do
            user = create_user(:login => 'TESTGUY')
            assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
            assert user.login == 'testguy'
        end
    end
    
    should "Not allow login with dot" do
        user = create_user(:login => 'test.guy')
        assert !user.valid?
    end

    should "Not allow login with dots" do
        user = create_user(:login => 'test.guy.guy')
        assert !user.valid?
    end
        
    should "Allow login with dash" do
        user = create_user(:login => 'test-guy')
        assert user.valid?
    end
    
    should "Not allow login with '@'" do
         user = create_user(:login => 'testguy@example.com')
         assert !user.valid?
    end         
        
    should "Not allow login with '!'" do
         user = create_user(:login => 'testguy!')
         assert !user.valid?
    end
     
    should "Fail to create a new user because they didn't agree to terms of service" do
        assert_no_difference 'User.count' do
            user = create_user(:terms_of_service => false)
            assert user.new_record?, "#{user.errors.full_messages.to_sentence}"
        end
    end
    
    should "initialize activation code upon creation" do
        user = create_user
        assert_not_nil user.activation_code
    end

    should "require login" do
        assert_no_difference 'User.count' do
            u = create_user(:login => nil)
            assert u.errors.on(:login)
        end
    end

    should "require password" do
        assert_no_difference 'User.count' do
            u = create_user(:password => nil)
            assert u.errors.on(:password)
        end
    end

    should "require password confirmation" do
        assert_no_difference 'User.count' do
            u = create_user(:password_confirmation => nil)
            assert u.errors.on(:password_confirmation)
        end
    end

    should "require require email" do
        assert_no_difference 'User.count' do
            u = create_user(:email => nil)
            assert u.errors.on(:email)
        end
    end

    should "require reset password email" do
        users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
        assert_equal users(:quentin), User.authenticate('quentin', 'new password')
    end

    should "not rehash password" do
        users(:quentin).update_attributes(:login => 'quentin2')
        assert_equal users(:quentin), User.authenticate('quentin2', 'test')
    end

    should "should authenticate user" do
        assert_equal users(:quentin), User.authenticate('quentin', 'test')
    end

    should "set remember token" do
        users(:quentin).remember_me
        assert_not_nil users(:quentin).remember_token
        assert_not_nil users(:quentin).remember_token_expires_at
    end

    should "unset remember token" do
        users(:quentin).remember_me
        assert_not_nil users(:quentin).remember_token
        users(:quentin).forget_me
        assert_nil users(:quentin).remember_token
    end

    should "remember me for one week" do
        before = 1.week.from_now.utc
        users(:quentin).remember_me_for 1.week
        after = 1.week.from_now.utc
        assert_not_nil users(:quentin).remember_token
        assert_not_nil users(:quentin).remember_token_expires_at
        assert users(:quentin).remember_token_expires_at.between?(before, after)
    end

    should "remember me until one week" do
        time = 1.week.from_now.utc
        users(:quentin).remember_me_until time
        assert_not_nil users(:quentin).remember_token
        assert_not_nil users(:quentin).remember_token_expires_at
        assert_equal users(:quentin).remember_token_expires_at, time
    end

    should "remember me default two weeks" do
        before = 2.weeks.from_now.utc
        users(:quentin).remember_me
        after = 2.weeks.from_now.utc
        assert_not_nil users(:quentin).remember_token
        assert_not_nil users(:quentin).remember_token_expires_at
        assert users(:quentin).remember_token_expires_at.between?(before, after)
    end

    # test friendships
    context 'users(:quentin)' do
        should 'be friends with users(:aaron)' do
            assert users(:quentin).friend_of?( users(:aaron) )
            assert users(:aaron).friend_of?( users(:quentin) )
        end

        should 'be following users(:friend_guy)' do
            assert users(:quentin).following?( users(:friend_guy) )
            assert users(:friend_guy).followed_by?( users(:quentin) )
        end
    end

    should "prefix with http" do
        p = users(:quentin)
        assert p.website.nil?
        assert p.website = 'example.com'
        assert p.save
        assert_equal 'http://example.com', p.reload.website
    end

    should "prefix with http4" do
        p = users(:quentin)
        assert p.website.nil?
        assert p.website = ''
        assert p.save
        assert_equal '', p.reload.website
    end

    should "prefix with http2" do
        p = users(:quentin)
        assert p.blog.nil?
        assert p.blog = 'example.com'
        assert p.save
        assert_equal 'http://example.com', p.reload.blog
    end

    should "prefix with friend_guy" do
        p = users(:quentin)
        assert p.flickr.nil?
        assert p.flickr = 'example.com'
        assert p.save
        assert_equal 'http://example.com', p.reload.flickr
    end

    should "have wall with aaron" do
        assert users(:quentin).has_wall_with(users(:aaron))
    end

    should "not have wall with friend_guy" do
        assert !users(:quentin).has_wall_with(users(:friend_guy))
    end

    def test_associations
        _test_associations
    end


    protected
    def create_user(options = {})
        User.create({ :login => 'quire', 
            :email => 'quire@example.com', 
            :password => 'quire', 
            :password_confirmation => 'quire', 
            :terms_of_service => true }.merge(options))
        end

end
