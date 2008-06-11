ActionController::Routing::Routes.draw do |map|

    # home
    map.with_options(:controller => 'home') do |home|
        home.home '/', :action => 'index'
        home.latest_comments '/latest_comments.rss', :action => 'latest_comments', :format=>'rss'
        home.newest_members '/newest_members.rss', :action => 'newest_members', :format=>'rss'
        home.tos '/tos', :action => 'terms'
        home.sitemap '/sitemap', :action => 'sitemap'
        home.contact '/contact', :action => 'contact'
    end

    # users
    map.resources :users, :member => { :enable => :put, :help => :get, :welcome => :get }, :has_many => :roles do |users|
        users.resource :account
    end
    
    map.with_options(:controller => 'users') do |users|
        users.signup  "/signup",  :action => 'new'
    end
    
    map.with_options(:controller => 'accounts') do |accounts|
        accounts.activate "/activate/:id",   :action => 'show'
        accounts.change_password '/change_password', :action => 'edit'
    end
    
    map.resource :password
    map.with_options(:controller => 'passwords') do |passwords|
        passwords.forgot_password "/forgot_password", :action => 'new'
        passwords.reset_password "/reset_password/:id", :action => 'edit'
    end    
    
    # sessions
    map.resource :session
    map.with_options(:controller => 'sessions') do |sessions|
        sessions.login "/login",   :action => 'new'
        sessions.logout "/logout",  :action => 'destroy'
        sessions.open_id_complete 'session', :action => "create", :requirements => { :method => :get }
    end
    
    # admin
    map.namespace :admin do |a|
        a.resources :users, :collection => {:search => :post}
        a.resources :roles
    end

    map.resources :profiles, 
        :member=>{:delete_icon=>:post}, :collection=>{:search=>:get}, 
        :has_many=>[:friends, :blogs, :photos, :comments, :feed_items, :messages]

    map.resources :messages, :collection => {:sent => :get}
    map.resources :blogs do |blog|
        blog.resources :comments
    end

    # Install the default routes as the lowest priority.
    map.connect ':controller/:action/:id'
    map.connect ':controller/:action/:id.:format'
end
