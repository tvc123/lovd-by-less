ActionController::Routing::Routes.draw do |map|
  map.resources :groups


    map.root :controller => 'home', :action => 'index'

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
    map.resources :users, :member => { :enable => :put, :help => :get, :welcome => :get, :delete_icon => :post }, 
                          :collection => { :is_login_available => :post, :is_email_available => :post }, 
                          :has_many => [:groups, :friends, :blogs, :photos, :comments, :feed_items, :messages, :roles] do |users|
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
    
    map.resources :profiles, :collection => { :search => :get }
    
    # groups
    map.resources :groups
    
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

    # messages
    map.resources :messages, :collection => {:sent => :get}
    
    # blogs
    map.resources :blogs do |blog|
        blog.resources :comments
    end

    # forums
    map.resources :forums, :collection => {:update_positions => :post} do |forum|
      forum.resources :topics, :controller => :forum_topics do |topic|
        topic.resources :posts, :controller => :forum_posts
      end
    end
    
    # Install the default routes as the lowest priority.
    map.connect ':controller/:action/:id'
    map.connect ':controller/:action/:id.:format'
end
