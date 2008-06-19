class CommentsController < ApplicationController
    
    include ApplicationHelper
    
    skip_filter :store_location, :only => [:create, :destroy]
    before_filter :setup

    def index
        @comments = Comment.between_users(current_user, @user).paginate(:page => @page, :per_page => @per_page)
        redirect_to current_user and return if is_me?(@user)
        respond_to do |format|
            format.html {render}
            format.rss {render :layout=>false}
        end
    end

    def create
        @comment = @parent.comments.new(params[:comment].merge(:user_id => current_user.id))

        respond_to do |format|
            if @comment.save!
                format.js do
                    render :update do |page|
                        page.insert_html :top, "#{dom_id(@parent)}_comments", :partial => 'comments/comment'
                        page.visual_effect :highlight, "comment_#{@comment.id}".to_sym
                        page << 'tb_remove();'
                        page << "jQuery('#comment_comment').val('');"
                    end
                end
            else
                format.js do
                    render :update do |page|
                        page << "message('Oops... I could not create that comment');"
                    end
                end
            end
        end
    end

    protected

    def parent; @blog || @user || nil; end

    def setup
        @user = User.find_by_login(params[:user_id])
        @blog = Blog.find(params[:blog_id]) unless params[:blog_id].blank?
        @parent = parent
    end

end
