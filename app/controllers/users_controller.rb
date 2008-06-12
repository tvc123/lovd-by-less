class UsersController < ApplicationController
 
    before_filter :not_logged_in_required, :only => [:new, :create] 
    before_filter :login_required, :only => [:show, :edit, :update]
    before_filter :check_administrator_role, :only => [:index, :destroy, :enable]

    def index
        @users = User.find(:all)
        respond_to do |format|
            format.html { render }
        end
    end

    # Show the user's home page.  This is their 'dash board'
    def show
        unless @profile.youtube_username.blank?
            begin
                client = YouTubeG::Client.new
                @video = client.videos_by(:user => current_user.profile.youtube_username).videos.first
            rescue Exception, OpenURI::HTTPError
            end
        end

        begin
            @flickr = @profile.flickr_username.blank? ? [] : flickr_images(flickr.people.findByUsername(current_user.profile.flickr_username))
        rescue Exception, OpenURI::HTTPError
            @flickr = []
        end    

        @comments = current_user.profile.comments.paginate(:page => @page, :per_page => @per_page)

        respond_to do |format|
            format.html do
                @feed_items = @profile.feed_items
            end
            format.rss do 
                @feed_items = @profile.feed_items
                render :layout => false
            end
        end
    end   
    
    
    def new
        @user = User.new
        respond_to do |format|
            format.html { render }
        end
    end

    def create
        cookies.delete :auth_token
        @user = User.new(params[:user])
        if AccountConfig::AUTOMATICALLY_ACTIVATE
            @user.force_activate!
        end
        @user.save!
        #Uncomment to have the user logged in after creating an account - Not Recommended
        #self.current_user = @user
        flash[:notice] = "Thanks for signing up! Please check your email to activate your account and then login."
        redirect_to welcome_user_path(@user)    
    rescue ActiveRecord::RecordInvalid
        respond_to do |format|
            format.html { render :action => "new" }
        end
    end

    def help
        respond_to do |format|
            format.html { render }
        end
    end

    def welcome
        @user = User.find(params[:id])
        respond_to do |format|
            format.html { render }
        end
    end

    def is_login_available
        result = 'Username not available'

        if params[:user_login].length <= 0
            result = ''
        elsif !User.login_exists?(params[:user_login])
            result = 'Username available'
        end
        respond_to do |format|
            format.html { render :text => result}
        end
    end

    # use this to manage user preferences
    # TODO need to examine the preferences code in the old system and bring it here
    def edit
        @user = current_user
    end

    def update
        @user = User.find(current_user)
        if @user.update_attributes(params[:user])
            flash[:notice] = "Preferences Updated"
            redirect_to user_url(@user)
        else
            render :action => 'edit'
        end
    end

    def destroy
        @user = User.find(params[:id])
        if @user.update_attribute(:enabled, false)
            flash[:notice] = "User disabled"
        else
            flash[:error] = "There was a problem disabling this user."
        end
        redirect_to :action => 'index'
    end

    def enable
        @user = User.find(params[:id])
        if @user.update_attribute(:enabled, true)
            self.current_user = @user
            flash[:notice] = "User enabled"
        else
            flash[:error] = "There was a problem enabling this user."
        end
        redirect_to :action => 'index'
    end

    protected 
    def allow_to
        super :owner, :except => [:enable]
        super :all, :only => [:new, :create, :help, :is_login_available]
    end
    
    def permission_denied      
        respond_to do |format|
            format.html do
                redirect_to user_path(current_user)
            end
        end
    end
    
end

