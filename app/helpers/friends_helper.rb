module FriendsHelper

    def get_friend_link user, target
        return wrap_get_friend_link(link_to('Sign-up to Follow', signup_path)) if user.blank?
        return '' unless user && target
        dom_id = user.dom_id(target.dom_id + '_friendship_')
        return wrap_get_friend_link('') if user == target
        return wrap_get_friend_link(link_to_remote( 'Stop Being Friends', :url => user_friend_path(user, target), :method => :delete), dom_id) if user.friend_of? target
        return wrap_get_friend_link(link_to_remote( 'Stop Following', :url => user_friend_path(user, target), :method => :delete), dom_id) if user.following? target
        return wrap_get_friend_link(link_to_remote( 'Be Friends', :url => user_friends_path(target), :method => :post), dom_id) if user.followed_by? target
        wrap_get_friend_link(link_to_remote( 'Start Following', :url => user_path(target), :method => :post), dom_id)
    end

    protected
    def wrap_get_friend_link str, dom_id = ''
        content_tag :span, str, :id=>dom_id, :class=>'friendship_description'
    end

end