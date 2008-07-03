class HomeController < ApplicationController
    skip_before_filter :login_required	

    def contact
        return unless request.post?
        body = []
        params.each_pair { |k,v| body << "#{k}: #{v}"  }
        HomeMailer.deliver_mail(:subject=>"from #{GlobalConfig.application_url_name} contact page", :body=>body.join("\n"))
        flash[:notice] = "Thank you for your message.  A member of our team will respond to you shortly."
        redirect_to contact_url    
    end


    def index
    # TODO remove this code.  it is just for testing    
#        user = User.find(:first)
 #       user.salesforce_sync
                
        respond_to do |format|
            format.html {render}
            format.rss {render :partial =>  'profiles/newest_member', :collection => new_members}
        end
    end

    def newest_members
        respond_to do |format|
            format.html {render :action=>'index'}
            format.rss {render :layout=>false}
        end
    end
    def latest_comments
        respond_to do |format|
            format.html {render :action=>'index'}
            format.rss {render :layout=>false}
        end
    end

    def terms
        render
    end

    def sitemap
        respond_to do |format|
            format.html { render }
        end
    end

    private

    def allow_to 
        super :all, :all=>true
    end

end


class HomeMailer < ActionMailer::Base
    def mail(options)
        self.generic_mailer(options)
    end
end