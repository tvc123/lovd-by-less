class FeedItemsController < ApplicationController
    
    include ApplicationHelper
    
    skip_filter :store_location
    before_filter :setup

    def destroy
        @user.feeds.find(:first, :conditions => {:feed_item_id=>params[:id]}).destroy

        respond_to do |format|
            format.html do
                flash[:notice] = 'Item successfully removed from the recent activities list.'
                redirect_back_or_default @user
            end
            format.js { render(:update){|page| page.visual_effect :puff, "feed_item_#{params[:id]}".to_sym}}
        end
    end  

    protected

    def setup
        @user = User.find_by_login(params[:user_id])
        if is_me?(@user)
            respond_to do |format|
                format.html do
                    flash[:notice] = "Sorry, you can't do that."
                    redirect_back_or_default @user
                end
                format.js { render(:update){|page| page.alert "Sorry, you can't do that."}}
            end
        end
    end
    
end