class ApplicationController < ActionController::Base

    layout 'application'

    helper :all

    #include ExceptionNotifiable
    include AuthenticatedSystem

    filter_parameter_logging "password"

    before_filter :login_from_cookie, :login_required, :setup_paging
    after_filter :store_location

    def setup_paging
        @page = (params[:page] || 1).to_i
        @page = 1 if @page < 1
        @per_page = (params[:per_page] || (RAILS_ENV=='test' ? 1 : 40)).to_i
    end

    helper_method :flickr, :flickr_images
    # API objects that get built once per request
    def flickr(user_name = nil, tags = nil )
        @flickr_object ||= Flickr.new(GlobalConfig.flickr_cache, GlobalConfig.flickr_key, GlobalConfig.flickr_secret)
    end

    def flickr_images(user_name = "", tags = "")
        unless RAILS_ENV == "test"# || RAILS_ENV == "development"
            begin
                flickr.photos.search(user_name.blank? ? nil : user_name, tags.blank? ? nil : tags , nil, nil, nil, nil, nil, nil, nil, nil, 20)
            rescue
                nil
            rescue Timeout::Error
                nil
            end
        end
    end    

end
