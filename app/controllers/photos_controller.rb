class PhotosController < ApplicationController

    skip_filter :login_required
    before_filter :setup
    
    def index
        respond_to do |format|
            format.html { render }
            format.rss { render :layout => false }
        end
    end

    def show
        redirect_to user_photos_path(@user)
    end

    def create
        @photo = current_user.photos.build params[:photo]

        respond_to do |format|
            if @photo.save
                format.html do
                    flash[:notice] = 'Photo successfully uploaded.'
                    redirect_to user_photos_path(current_user)
                end
            else
                format.html do
                    flash.now[:error] = 'Photo could not be uploaded.'
                    render :action => :index
                end
            end
        end
    end

    def destroy
        Photo[params[:id]].destroy
        respond_to do |format|
            format.html do
                flash[:notice] = 'Photo was deleted.'
                redirect_to user_photos_path(current_user)
            end
        end
    end

    private
    
    def setup
        @user = User.find_by_login(params[:user_id])
        @photos = @user.photos.paginate(:all, :page => @page, :per_page => @per_page)
        @photo = Photo.new
    end
end