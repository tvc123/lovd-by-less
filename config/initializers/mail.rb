# Email settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address => "mail.jbasdf.com",
    :port => 25,
    :domain => "jbasdf.com",
    :authentication => :login,
    :user_name => "jbasdf@jbasdf.com",
    :password => "1qazxsw2"  
}

