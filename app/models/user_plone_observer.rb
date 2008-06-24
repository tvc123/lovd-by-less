class UserPloneObserver < ActiveRecord::Observer

    observe User
    
    def before_save(user)
        return if user.nil?
        return if user.password.nil?
        return if user.password.empty?
        user.plone_password = Digest::SHA1.hexdigest("#{user.password}") 
    end

    def after_create(user)
        
        # require 'xmlrpc/client'
        #        require 'pp'
        #        
        #        group_member = PloneGroupRole.find_by_login(user.login) || PloneGroupRole.create(:login => user.login, :rolename => 'Member')
        #        open_contributor = PloneOpenRole.find_by_login(user.login) || PloneOpenRole.create(:login => user.login, :rolename => 'Contributor')
        #        open_member = PloneOpenRole.find_by_login(user.login) || PloneOpenRole.create(:login => user.login, :rolename => 'Member')
        #        
        #        server = XMLRPC::Client.new(GlobalConfig.plone_xmlrpc_server, GlobalConfig.plone_xmlrpc_path, GlobalConfig.plone_xmlrpc_port, nil, nil, user.login, user.password, false, 2000)   
        #        result = server.call2('xmlrpc_createMemberArea', user.login)
        
        STARLING.set(GlobalConfig.starling_plone_user_queue, {:user_id => user.id})
    end
    
end