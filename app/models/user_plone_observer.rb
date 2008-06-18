class UserPloneObserver < ActiveRecord::Observer

    observe User
    
    def before_save(user)
        user.plone_password = Digest::SHA1.hexdigest("#{user.password}") unless user.password.empty?
    end
    
end