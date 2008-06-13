class ProfilesController < ApplicationController
    
    include ApplicationHelper

    before_filter :search_results, :only => [:index, :search]
    skip_filter :login_required

    def search
        render
    end

    def index
        render :action => :search
    end
    
    # show a given user's public profile information
    def show
        
        @user = User.find_by_login(params[:id])
        
        unless @user.youtube_username.blank?
            begin
                client = YouTubeG::Client.new
                @video = client.videos_by(:user => @user.youtube_username).videos.first
            rescue Exception, OpenURI::HTTPError
            end
        end

        begin
            @flickr = @user.flickr_username.blank? ? [] : flickr_images(flickr.people.findByUsername(@user.flickr_username))
        rescue Exception, OpenURI::HTTPError
            @flickr = []
        end    

        @comments = @user.comments.paginate(:page => @page, :per_page => @per_page)

        respond_to do |format|
            format.html do
                @feed_items = @user.feed_items
            end
            format.rss do 
                @feed_items = @user.feed_items
                render :layout => false
            end
        end
    end

    private

    def search_results
        if params[:search]
            p = params[:search].dup
        else
            p = []
        end
        @results = User.search((p.delete(:q) || ''), p).paginate(:page => @page, :per_page => @per_page)
    end

end
