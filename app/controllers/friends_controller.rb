class FriendsController < ApplicationController
    
    before_filter :setup
    skip_before_filter :login_required, :only=>:index
    skip_before_filter :store_location, :only => [:create, :destroy]

    def create
        respond_to do |format|
            if Friend.make_friends(current_user, @user)
                friend = current_user.reload.friend_of? @user
                format.js {render( :update ){|page| page.replace current_user.dom_id(@user.dom_id + '_friendship_'), get_friend_link( current_user, @user)}}
            else
                message = "Oops... That didn't work. Try again!"
                format.js {render( :update ){|page| page.alert message}}
            end
        end
    end

    def destroy
        Friend.reset current_user, @user
        respond_to do |format|
            following = current_user.reload.following? @user
            format.js {render( :update ){|page| page.replace current_user.dom_id(@user.dom_id + '_friendship_'), get_friend_link( current_user, @user)}}
        end
    end

    def index
        respond_to do |format|
            format.html
        end
    end

    protected

    def setup
        @user = User.find_by_login(params[:user_id]) || User[params[:id] || params[:user_id]].user
    end

end
