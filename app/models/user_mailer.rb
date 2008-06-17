class UserMailer < ActionMailer::Base

    def signup_notification(user)
        setup_email(user)

        # Email header info
        @subject = "Welcome to #{AccountConfig::APPLICATION_NAME}!"

        # Email body substitutions
        @body[:login] = "#{user.login}"
        @body[:url]  = "http://#{AccountConfig::APPLICATION_URL}/activate/#{user.activation_code}"

        #render :file => "user_mailer/signup_notification"
    end

    def activation(user)
        setup_email(user)
        @subject    = "Your #{AccountConfig::APPLICATION_NAME} account has been activated!"
        @body[:url]  = "http://#{AccountConfig::APPLICATION_URL}/"
    end

    def forgot_password(user)
        setup_email(user)
        @subject    = "You have requested to change your #{AccountConfig::APPLICATION_NAME} password"
        @body[:url]  = "http://#{AccountConfig::APPLICATION_URL}/reset_password/#{user.password_reset_code}"
    end

    def reset_password(user)
        setup_email(user)
        @subject    = "Your #{AccountConfig::APPLICATION_NAME} password has been reset."
    end

    def follow inviter, invited, description
        @subject        = "Follow notice from #{SITE_NAME}"
        @recipients     = invited.email
        @body['inviter']   = inviter
        @body['invited']   = invited
        @body['description'] = description
        @from           = MAILER_FROM_ADDRESS
        @sent_on        = Time.new
        @headers        = {}
    end

    protected
    def setup_email(user)
        @recipients  = "#{user.email}"
        @from        = "#{AccountConfig::EMAIL_FROM}"
        @sent_on     = Time.now
        @body[:user] = user
    end
end




