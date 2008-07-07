# class for communicating with salesforce
class Contact < ActiveRecord::Base
    establish_connection :salesforce_production
    #include ActiveSalesforce::ActiveRecord::Mixin
    #set_table_name "contact"
end