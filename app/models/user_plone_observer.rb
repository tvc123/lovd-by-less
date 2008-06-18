class UserPloneObserver < ActiveRecord::Observer

    observe User
    
    def before_save(user)
        return if user.nil?
        return if user.password.empty?
        user.plone_password = Digest::SHA1.hexdigest("#{user.password}") 
    end
    
end