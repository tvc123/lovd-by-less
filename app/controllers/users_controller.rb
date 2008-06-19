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
        
        @user = current_user
        
        unless current_user.youtube_username.blank?
            begin
                client = YouTubeG::Client.new
                @video = client.videos_by(:user => current_user.youtube_username).videos.first
            rescue Exception, OpenURI::HTTPError
            end
        end

        begin
            @flickr = current_user.flickr_username.blank? ? [] : flickr_images(flickr.people.findByUsername(current_user.flickr_username))
        rescue Exception, OpenURI::HTTPError
            @flickr = []
        end    

        @comments = current_user.comments.paginate(:page => @page, :per_page => @per_page)

        respond_to do |format|
            format.html do
                @feed_items = current_user.feed_items
            end
            format.rss do 
                @feed_items = current_user.feed_items
                render :layout => false
            end
        end
    end   

    def new
        @user = User.new
        #@users = User.find(:all, :order => "name" ).map {|u| [u.name, u.id] }
        setup_form_values
        respond_to do |format|
            format.html { render }
        end
    end
    
    def create
        cookies.delete :auth_token
        @user = User.new(params[:user])
        if GlobalConfig.automatically_activate
            @user.force_activate!
        end
        
      
        #This code is for the Grade Level Experience
        @levels = GradeLevelExperience.find(:all)
        selected_levels = []
        for level_id_char in params[:grade_level_experiences]
          level= GradeLevelExperience.find(level_id_char.to_i)
          if not @user.grade_level_experiences.include?(level)
            @user.grade_level_experiences << level
          end
          selected_levels << level
        end

        missing_levels = @levels - selected_levels

        for level in missing_levels

          if @user.grade_level_experiences.include?(level)
            @user.grade_level_experiences.delete(level)
          end
        end  
      
      
       #This code is for the additional languages
        @languages = Language.find(:all)
        selected_languages = []
        for lang_id_char in params[:other_languages]
          language= Language.find(lang_id_char.to_i)
          if not @user.languages.include?(language)
            @user.languages << language
          end
          selected_languages << language
        end

        missing_languages = @languages - selected_languages

        for language in missing_languages

          if @user.languages.include?(language)
            @user.languages.delete(language)
          end
        end  
      
      
        @user.save!
        #Uncomment to have the user logged in after creating an account - Not Recommended
        #self.current_user = @user
        flash[:notice] = "Thanks for signing up! Please check your email to activate your account and then login."
        redirect_to welcome_user_path(@user)
           
    rescue ActiveRecord::RecordInvalid # => e
        setup_form_values
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
        @user = User.find_by_login(params[:id])
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

    def edit
        @user = current_user
        setup_form_values
    end

    def update
        @user = User.find(current_user)
     
        if @user.update_attributes params[:user]
            flash[:notice] = "Settings have been saved."
            redirect_to edit_user_url(@user)
        else
            flash.now[:error] = @user.errors
            setup_form_values
            respond_to do |format|
                format.html { render :action => :edit}
            end
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

        #TODO figure out what to do here - should we really delete the account or just disable it?
           # respond_to do |format|
           #               @user.destroy
           #               cookies[:auth_token] = {:expires => Time.now-1.day, :value => ""}
           #               session[:user] = nil
           #               format.js do
           #                   render :update do |page| 
           #                       page.alert('Your user account, and all data, have been deleted.')
           #                       page << 'location.href = "/";'
           #                   end
           #               end
           #           end
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

    def delete_icon
        respond_to do |format|
        current_user.update_attribute :icon, nil
        format.js {render :update do |page| page.visual_effect 'Puff', 'user_icon_picture' end  }
        end      
    end

    protected 

    def permission_denied      
        respond_to do |format|
            format.html do
                redirect_to user_path(current_user)
            end
        end
    end
    
    def setup_form_values
        @states = State.find(:all, :order => "name" ).map {|u| [u.name, u.id] }
        @countries = Country.find(:all, :order => "name" ).map {|u| [u.name, u.id] }
        @grade_level_experiences = GradeLevelExperience.find(:all).map {|u| [u.name, u.id] }
        @languages = Language.find(:all).map {|u| [u.english_name, u.id] }
    end

end

