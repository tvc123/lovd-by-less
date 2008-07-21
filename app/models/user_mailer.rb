class UserMailer < ActionMailer::Base

    def signup_notification(user)
        setup_email(user)

        # Email header info
        @subject = "Welcome to #{GlobalConfig.application_name}!"

        # Email body substitutions
        @body[:login] = "#{user.login}"
        @body[:url]  = "http://#{GlobalConfig.application_url}/activate/#{user.activation_code}"

        #render :file => "user_mailer/signup_notification"
    end

    def reset_notification(user)
        setup_email(user)

        # Email header info
        @subject = "Your #{GlobalConfig.application_name} has not yet been activated"

        # Email body substitutions
        @body[:login] = "#{user.login}"
        @body[:reset_url]  = "http://#{GlobalConfig.application_url}/reset_password"
        @body[:activate_url]  = "http://#{GlobalConfig.application_url}/activate/#{user.activation_code}"
    end
    
    def activation(user)
        setup_email(user)
        @subject    = "Your #{GlobalConfig.application_name} account has been activated!"
        @body[:url]  = "http://#{GlobalConfig.application_url}/"
    end

    def forgot_password(user)
        setup_email(user)
        @subject    = "You have requested to change your #{GlobalConfig.application_name} password"
        @body[:url]  = "http://#{GlobalConfig.application_url}/reset_password/#{user.password_reset_code}"
    end

    def reset_password(user)
        setup_email(user)
        @subject    = "Your #{GlobalConfig.application_name} password has been reset."
    end

    def follow inviter, invited, description
        @subject        = "Follow notice from #{GlobalConfig.application_url_name}"
        @recipients     = invited.email
        @body['inviter']   = inviter
        @body['invited']   = invited
        @body['description'] = description
        @from           = GlobalConfig.email_from
        @sent_on        = Time.new
        @headers        = {}
    end

    protected
    def setup_email(user)
        @recipients  = "#{user.email}"
        @from        = "#{GlobalConfig.email_from}"
        @sent_on     = Time.now
        @body[:user] = user
    end
end




