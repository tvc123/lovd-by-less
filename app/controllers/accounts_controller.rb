class AccountsController < ApplicationController
 
    before_filter :login_required, :except => :show
    before_filter :not_logged_in_required, :only => :show

    # Activate action
    def show
        # Uncomment and change paths to have user logged in after activation - not recommended
        #self.current_user = User.find_and_activate!(params[:id])
        user = User.find_and_activate!(params[:id])
        
        if GlobalConfig.integrate_plone
            if Plone.user_to_plone(user, user.tmp_password)
                user.tmp_password = ''
                user.save
            end             
        end
               
        flash[:notice] = "Your account has been activated! You can now login."
        redirect_to login_path
    rescue User::ArgumentError
        flash[:notice] = 'Activation code not found. Please try creating a new account.'
        redirect_to new_user_path 
    rescue User::ActivationCodeNotFound
        flash[:notice] = 'Activation code not found. Please try creating a new account.'
        redirect_to new_user_path
    rescue User::AlreadyActivated
        flash[:notice] = 'Your account has already been activated. You can log in below.'
        redirect_to login_path
    end

    def edit
    end

    # Change password action  
    def update
        return unless request.post?
        if User.authenticate(current_user.login, params[:old_password])
            if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
                current_user.password_confirmation = params[:password_confirmation]
                current_user.password = params[:password]        
                if current_user.save
                    flash[:notice] = "Password successfully updated."
                    redirect_to user_path(current_user)                    
                else
                    flash[:error] = "An error occured, your password was not changed."
                    render :action => 'edit'
                end
            else
                flash[:error] = "New password does not match the password confirmation."
                @old_password = params[:old_password]
                render :action => 'edit'      
            end
        else
            flash[:error] = "Your old password is incorrect."
            render :action => 'edit'
        end 
    end
    
    private
    def allow_to
      super :owner, :all => true
      super :all, :only => [:show]
    end
    
end

