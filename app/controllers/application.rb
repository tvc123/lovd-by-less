class ApplicationController < ActionController::Base
    
    layout 'application'

    helper :all

    include ExceptionNotifiable
    include AuthenticatedSystem

    filter_parameter_logging "password"

    before_filter :allow_to, :login_from_cookie, :login_required, :check_permissions, :pagination_defaults
    after_filter :store_location

    def pagination_defaults
        @page = (params[:page] || 1).to_i
        @page = 1 if @page < 1
        @per_page = (params[:per_page] || (RAILS_ENV=='test' ? 1 : 40)).to_i
    end

    helper_method :flickr, :flickr_images
    # API objects that get built once per request
    def flickr(user_name = nil, tags = nil )
        @flickr_object ||= Flickr.new(FLICKR_CACHE, FLICKR_KEY, FLICKR_SECRET)
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

    protected

    def allow_to level = nil, args = {}
        return unless level
        @level ||= []
        @level << [level, args]    
    end

    def check_permissions
        return true
        # TODO fix permissions
        logger.debug "IN check_permissions :: @level => #{@level.inspect}"
        return failed_check_permissions if current_user.profile && !current_user.is_active
        return true if current_user && current_user.is_admin
        raise '@level is blank. Did you override the allow_to method in your controller?' if @level.blank?
        @level.each do |l|
            next unless (l[0] == :all) || 
            (l[0] == :non_user && !current_user) ||
            (l[0] == :user && current_user) ||
            (l[0] == :owner && @p && @profile && @p == @profile)
            args = l[1]
            @level = [] and return true if args[:all] == true

            if args.has_key? :only
                actions = [args[:only]].flatten
                actions.each{ |a| @level = [] and return true if a.to_s == action_name}
            end
        end
        return failed_check_permissions
    end

    def failed_check_permissions
        if RAILS_ENV != 'development'
            flash[:error] = 'It looks like you don\'t have permission to view that page.'
            redirect_back_or_default home_path and return true
        else
            render :text => "<h1>It looks like you don't have permission to view this page.</h1>
                <div>
                Permissions: #{@level.inspect}<br />
                Controller: #{controller_name}<br />
                Action: #{action_name}<br />
                Params: #{params.inspect}<br />
                Session: #{session.instance_variable_get("@data").inspect}<br/>
                </div>"
            
        end
        @level = []
        false
    end

end
