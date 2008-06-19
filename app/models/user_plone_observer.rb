class UserPloneObserver < ActiveRecord::Observer

    observe User
    
    def before_save(user)
        return if user.nil?
        return if user.password.nil?
        return if user.password.empty?
        user.plone_password = Digest::SHA1.hexdigest("#{user.password}") 
    end

    def after_create(user)
        group_member = PloneGroupRole.find_by_login(user.login) || PloneGroupRole.create(:login => user.login, :rolename => 'Member')
        open_contributor = PloneOpenRole.find_by_login(user.login) || PloneOpenRole.create(:login => user.login, :rolename => 'Contributor')
        open_member = PloneOpenRole.find_by_login(user.login) || PloneOpenRole.create(:login => user.login, :rolename => 'Member')
    end
    
end
