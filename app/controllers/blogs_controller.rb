class BlogsController < ApplicationController
   
    #web_service_api BloggerAPI
   
    include ApplicationHelper
    
    skip_filter :login_required, :only => [:index, :show]
    before_filter :setup

    def index
        if logged_in? && is_me?(@user) && @user.blogs.empty?
            flash[:notice] = 'You have not create any blog posts.  Try creating one now.'
            redirect_to new_user_blog_path(@user) and return
        end
        respond_to do |format|
            format.html {render}
            format.rss {render :layout=>false}
        end
    end

    def create
        @blog = current_user.blogs.build params[:blog]

        respond_to do |format|
            if @blog.save
                format.html do
                    flash[:notice] = 'New blog post created.'
                    redirect_to user_blogs_path(current_user)
                end
            else
                format.html do
                    flash.now[:error] = 'Failed to create a new blog post.'
                    render :action => :new
                end
            end
        end
    end

    def show
        render
    end

    def edit
        render
    end

    def update
        respond_to do |format|
            if @blog.update_attributes(params[:blog])
                format.html do
                    flash[:notice]='Blog post updated.'
                    redirect_to user_blogs_path(current_user)
                end
            else
                format.html do
                    flash.now[:error]='Failed to update the blog post.'
                    render :action => :edit
                end
            end
        end
    end

    def destroy
        @blog.destroy
        respond_to do |format|
            format.html do
                flash[:notice]='Blog post deleted.'
                redirect_to user_blogs_path(current_user)
            end
        end
    end

    protected

    def setup
        @user = User.find_by_login(params[:user_id])
        @blogs = @user.blogs.paginate(:page => @page, :per_page => @per_page)

        if params[:id]
            @blog = Blog[params[:id]]
        else
            @blog = Blog.new
        end
    end

end
