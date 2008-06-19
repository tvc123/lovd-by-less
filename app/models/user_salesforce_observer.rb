class UserSalesforceObserver < ActiveRecord::Observer
    
    observe User
    
    def after_save(user)
        # send data to salesforce
    end
    
end