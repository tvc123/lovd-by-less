namespace :plone do 
    task (:starling => :environment) do
            
        require 'xmlrpc/client'
        require 'pp'
        require 'memcache'
                 
        loop do 
            message = STARLING.get(GlobalConfig.starling_plone_user_queue) 
            if message
                user = User.find(message[:user_id])
                if user
                    begin 
                        logger.info "Adding plone groups" 
                        group_member = PloneGroupRole.find_by_login(user.login) || PloneGroupRole.create(:login => user.login, :rolename => 'Member')
                        open_contributor = PloneOpenRole.find_by_login(user.login) || PloneOpenRole.create(:login => user.login, :rolename => 'Contributor')
                        open_member = PloneOpenRole.find_by_login(user.login) || PloneOpenRole.create(:login => user.login, :rolename => 'Member')

                        logger.info "Creating user folder on plone site"
                        server = XMLRPC::Client.new(GlobalConfig.plone_xmlrpc_server, GlobalConfig.plone_xmlrpc_path, GlobalConfig.plone_xmlrpc_port, nil, nil, user.login, user.password, false, 2000)   
                        result = server.call2('xmlrpc_createMemberArea', user.login)
                    rescue Exception => e
                        logger.info "Error setting up user's plong integration: " + e.message
                        # something failed try again later
                        starling.set(GlobalConfig.starling_plone_user_queue, message)
                    end 
                end
            end
            $stdout.flush 
            sleep(10)
        end 
    end 
end