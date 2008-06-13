# Change globals to match the proper value for your site

DELETE_CONFIRM = "Are you sure you want to delete?\nThis can not be undone."
SEARCH_LIMIT = 25
SITE_NAME = 'Teachers Without Borders'
SITE = RAILS_ENV == 'production' ? 'twb1.enpraxis.net:8080' : 'localhost:3000'

MAILER_TO_ADDRESS = 'info@#{SITE}'
MAILER_FROM_ADDRESS = 'The Teachers Without Borders Team <info@teacherswithoutborders.org>'
REGISTRATION_RECIPIENTS = %W() #send an email to this list everytime someone signs up

YOUTUBE_BASE_URL = "http://gdata.youtube.com/feeds/api/videos/"

APPLICATION_BASE_URL = '.enpraxis.net' # for cookies that need to work accross all subdomains (the plone site)
