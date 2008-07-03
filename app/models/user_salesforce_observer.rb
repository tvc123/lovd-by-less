class UserSalesforceObserver < ActiveRecord::Observer

    observe User

    def after_save(user)
        begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
            user.salesforce_sync
        rescue 
            #Huge HACK because the call will suceed the second time around ... who knows why
            after_update(user)
        end
    end


    def after_update(user)
        begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
            user.salesforce_sync
        rescue 
            #Huge HACK because the call will suceed the second time around ... who knows why
            after_update(user)
        end

    end

end

