require 'avatar/view/action_view_support'

module UsersHelper

    include Avatar::View::ActionViewSupport

    def icon user, size = :small, img_opts = {}
        return "" if user.nil?
        img_opts = {:title => user.full_name, :alt => user.full_name, :class => size}.merge(img_opts)
        link_to(avatar_tag(user, {:size => size, :file_column_version => size }, img_opts), profile_path(user))
    end

    def location_link user = current_user
        return user.location if user.location == 'No Where'
        link_to h(user.location), search_profiles_path.add_param('search[location]' => user.location)
    end

    def user_has_grade_level_experience?(level)
        if @user && !@user.login.nil? # no sense in testing new users that have no grade levels
            @user.grade_level_experiences.include?(level)
        else
            false
        end
    end

    def user_speaks_language?(language)
        if @user && !@user.login.nil? # no sense in testing new users that have no languages
            @user.languages.include?(language)
        else
            false
        end
    end
    
end
