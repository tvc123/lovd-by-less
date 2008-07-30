require 'avatar/view/action_view_support'

module UsersHelper

    include Avatar::View::ActionViewSupport

    def location_link user = current_user
        return user.location if user.location == 'No Where'
        link_to h(user.location), search_profiles_path.add_param('search[location]' => user.location)
    end

    def user_has_grade_level_experience?(level)
        if @user && !@user.login.nil? # no sense in testing new users that have no grade levels
            @user_grade_level_experience_ids ||=  @user.grade_level_experiences.collect{|level| level.id}
            @user_grade_level_experience_ids.include?(level.id)
        else
            false
        end
    end

    def user_speaks_language?(language)
        if @user && !@user.login.nil? # no sense in testing new users that have no languages
            @user_language_ids ||= @user.languages.collect{|language| language.id}
            @user_language_ids.include?(language.id)
        else
            false
        end
    end
    
end
