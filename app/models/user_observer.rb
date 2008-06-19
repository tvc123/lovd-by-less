class UserObserver < ActiveRecord::Observer
    
    def after_create(user)
        UserMailer.deliver_signup_notification(user)
    end

    def after_save(user)
        if !GlobalConfig.automatically_activate
            #UserMailer.deliver_activation(user) if user.recently_activated? 
            UserMailer.deliver_activation(user) if user.pending?
        end
        UserMailer.deliver_forgot_password(user) if user.recently_forgot_password?
        UserMailer.deliver_reset_password(user) if user.recently_reset_password?
    end
    
end