require File.dirname(__FILE__) + '/../test_helper'
require 'user_mailer'

class UserMailerTest < Test::Unit::TestCase
    
    fixtures :users
    
    FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
    CHARSET = "utf-8"

    include ActionMailer::Quoting

    def setup
        ActionMailer::Base.delivery_method = :test
        ActionMailer::Base.perform_deliveries = true
        ActionMailer::Base.deliveries = []

        @expected = TMail::Mail.new
        @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    end

    should "send signup notification email" do
        user = User.find(users(:quentin))
        response = UserMailer.create_signup_notification(user)   
        assert_match "Welcome to #{AccountConfig::APPLICATION_NAME}!", response.subject
        assert_match "#{user.login}", response.body
        assert_match "http://#{AccountConfig::APPLICATION_URL}/activate/#{user.activation_code}", response.body    
        assert_equal user.email, response.to[0]
    end

    should "send signup activation email" do
        user = User.find(users(:quentin))
        response = UserMailer.create_activation(user) 
        assert_match "Your #{AccountConfig::APPLICATION_NAME} account has been activated!", response.subject
        assert_equal user.email, response.to[0]
    end

    should "send forgot password email" do
        user = User.find(users(:quentin))
        response = UserMailer.create_forgot_password(user)   
        assert_match "You have requested to change your #{AccountConfig::APPLICATION_NAME} password", response.subject
        assert_equal user.email, response.to[0]
    end
    
    should "send password reset email" do
        user = User.find(users(:quentin))
        response = UserMailer.create_reset_password(user)
        assert_match "Your #{AccountConfig::APPLICATION_NAME} password has been reset", response.subject     
        assert_match /Your password has been reset/, response.body           
        assert_equal user.email, response.to[0]
    end
    
    private
    def read_fixture(action)
        IO.readlines("#{FIXTURES_PATH}/user_mailer/#{action}")
    end

    def encode(subject)
        quoted_printable(subject, CHARSET)
    end
end