require 'xmlrpc/client'

class PloneWorker < Workling::Base

    def process_plone_users(options = {})

        user = User.find(options[:user_id])
        if user
            begin 
                
                logger.info "***********************************************************************"
                logger.info "Adding plone groups" 
                group_member = PloneGroupRole.find_by_login(user.login) || PloneGroupRole.create(:login => user.login, :rolename => 'Member')
                open_contributor = PloneOpenRole.find_by_login(user.login) || PloneOpenRole.create(:login => user.login, :rolename => 'Contributor')
                open_member = PloneOpenRole.find_by_login(user.login) || PloneOpenRole.create(:login => user.login, :rolename => 'Member')

                logger.info "Creating user folder on plone site"
                server = XMLRPC::Client.new(GlobalConfig.plone_xmlrpc_server, GlobalConfig.plone_xmlrpc_path, GlobalConfig.plone_xmlrpc_port, nil, nil, user.login, options[:password], false, 2000)   
                result = server.call2('xmlrpc_createMemberArea', user.login)

                if result[0] == false
                    logger.info result[1].faultString
                end
                
                logger.info "***********************************************************************"
            rescue Exception => e
                logger.info "Error setting up user's plone integration: " + e.message
                # something failed try again later
                PloneWorker.asynch_process_plone_users(:user_id => user.id)
            end 
        end

    end
    
end

