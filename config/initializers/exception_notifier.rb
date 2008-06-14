# Add the emails which should receive exception notifications below.  ie: %W(admin1@yoursite.com admin2@yoursite.com)
ExceptionNotifier.sender_address =  %("Name Error <error@teacherswithoutborders.org>")
ExceptionNotifier.email_prefix = "TWB Error: "

ExceptionNotifier.exception_recipients = %w(justin@teacherswithoutborders.org)
ExceptionNotifier.class_eval do 
  remove_method :template_root 
  ExceptionNotifier.template_root = "#{RAILS_ROOT}/vendor/plugins/exception_notification/lib/../views" 
end