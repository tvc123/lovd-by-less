class GroupsController < ApplicationController
    
    before_filter :login_required, :except => [:index, :show, :members, :latest, :vote_story, :community_tags, :communities_that_use_tags]
    
    #############################################################
    # show the list of communities
    def index
        @page_title = "Browse Groups"

        @current_tab = params[:tab]
        @current_tab = "popular" if !@current_tab

        @offset = params[:offset]
        @offset = @offset ? @offset.to_i : 0

        @limit = params[:limit]
        @limit = @limit && @limit.to_i < ENTRIES_PER_PAGE ? @limit.to_i : ENTRIES_PER_PAGE
        
        @total_items = Community.count
        @page = @offset / @limit + 1
        @pages = @total_items / @limit + 1

        @communities = Community.get_communities(current_user ? current_user.id : 0, 
                                                 @current_tab, 
                                                 :limit => @limit,
                                                 :offset => @offset)
#        if @communities
#            @featured_community = @communities[rand(@communities.length)]
#            @featured_tags = @featured_community.get_tags_for_shared_entries
#        else
        if !@communities
            render :text => "There are no groups!"
        end
    end
    
    #############################################################
    # create community. Checks to see if the group name exists and if not
    # assumes this is the first post to the page. Otherwise it will
    # check to see if the group exists and if it does, throws an error
    # message. If not, the group is created.
    def create
        if params[:group_name]
            @has_errors = false
            if  Community.find_by_title(params[:group_title])
                @msg = "Group Title '#{params[:group_title]}' has already been taken. Please choose a new community title."
                @has_errors = true
            elsif Community.find_by_name(params[:group_name])
                @msg = "Group Name '#{params[:group_name]}' has already been taken. Please choose a new community name."
                @has_errors = true
            end

            if request.post? and !@has_errors
                #save the image to file
                @community_name = params[:group_name]
        
                if params[:picture_file].original_filename != ""
                    save_image(params[:picture_file], params[:group_name])
                    new_community = Community.new(:title => params[:group_title], 
                                              :name => @community_name,
                                              :description => params[:group_description], 
                                              :image_path => params[:group_name])
                else
                    new_community = Community.new(:title => params[:group_title], 
                                              :name => @community_name,
                                              :description => params[:group_description])
                end
    
                if !new_community.save!
                    @msg = "Unable to create community"
                    @has_errors = true
                else
                    @msg = "Community created " + params[:group_title].to_s
                    CommunitiesUser.create(:community_id => new_community.id, 
                                           :user_id => current_user.id,
                                           :role_id => Community::ROLE_CREATOR)
                end
                @my_communities = User.find(current_user.id).communities.find(:all, :order => "title")
                redirect_to :controller => 'community', :action => params[:group_name]
            end
        end        
    end
    
    #############################################################
    # create community
    def edit
        @has_errors = false
        if request.post?                                          
            @community_name = params[:group_name]
            edit_community = Community.find_by_name(@community_name)
            edit_community.description = params[:group_description]
            if params[:picture_file].original_filename != ""
                #save the image to file
                save_image(params[:picture_file], params[:group_name])
                edit_community.image_path = @community_name
            end
    
            if !edit_community.save!
                @msg = "Unable to edit community"
                @has_errors = true
            else
                @msg = "Community edited " + params[:group_title].to_s
            end
        end
        @my_communities = User.find(current_user.id).communities.find(:all, :order => "title")
        redirect_to :controller => 'community', :action => @community_name
    end
    
    ##########################################################        
    #save the image to file
    def save_image(newfile, filename)
        uploaded_file = newfile
        if uploaded_file.original_filename != ""
            s1 = sanitize_filename(uploaded_file.original_filename).split(".")
            ext_type = s1[(s1.length - 1)].downcase
            if ext_type == "jpg" || ext_type == "gif" || ext_type == "png" || ext_type == "jpeg" || ext_type == "bmp" || ext_type == "tif" ||ext_type == "tiff"  

                File.open("#{RAILS_ROOT}/public/images/temp/#{filename}.jpg", "wb") do |f| f.write(uploaded_file.read)
                end
                submit_crop_image(filename, "#{RAILS_ROOT}/public/images/groups/")                                
            end
        end
    
    end
    
    ##########################################################
    # view the user's groups
    def my_groups
        @page_title = "My Ozmozr Groups"
        @user = User.find(current_user.id)
        @my_communities = @user.communities.find(:all, :order => "title")
        
        @community_name = params[:name]
        @community_name = "all" if !@community_name
        
        @current_tab = params[:tab]
        @current_tab = "popular" if !@current_tab
        
        if @community_name == "all"
            if @current_tab == "popular"
                @entries = @user.get_entries_shared_to_communities
            else
                @entries = @user.get_entries_from_community_feeds
            end
        else
            @community = Community.find_by_name(@community_name)
            if @current_tab == "popular"
                @entries = @community.get_shared_entries(@user.id, :limit => 10)
            else
                @entries = @community.get_entries(:limit => 10)
            end
        end      
    end
    
    #############################################################
    # add a feed to the community
    def add_feed
        @community = Community.find_by_name(params[:name])
        if @community
            @community.add_feed(params[:feed][:feed_id])
            redirect_to(:action => :feed)
        end
    end
    
    #############################################################
    # contribute something to this feed
    def contribute
        @community = Community.find_by_name(params[:name])
        @available_services = Service.find(:all)
        @submit_value = "Contribute"
        if request.post?
            login = ""
            password = ""
            service_id = 0
            
            # Find the user
            user = User.find(current_user.id)
            uri = params[:complex_feed][:uri]
            title = params[:complex_feed][:title]
            tags = params[:complex_feed][:tags]
            my_feed = params[:complex_feed][:my_feed]
            
            @complex_feed = ComplexFeed.new(user, uri, title, tags, my_feed, login, password, service_id)
            
            if @complex_feed.save
                flash[:message] = "Added Feed"
                cf = CommunitiesFeed.new(:community_id => @community.id, :feed_id => @complex_feed.feed_id)
                if cf.save
                    redirect_to(:controller => "community", :action => "show", :name => @community.name)
                end
            end            
        end
    end
    
    #############################################################
    # show the home page for a community
    def show(tags = nil)
        user_id = current_user ? current_user.id : 0
        @community = Community.get_community(params[:name], user_id)
        @tags = params[:tags] || tags

        # found the community
        if nil != @community
            @page = 1 || params[:page]

            # tags have been specified
            if @tags && @tags.length > 0
                @entries = @community.get_shared_entries_tagged(user_id, @tags, 
                                            :limit => ENTRIES_PER_PAGE,
                                            :offset => (ENTRIES_PER_PAGE * (@page - 1)))
            else
                @entries = @community.get_shared_entries(user_id, :limit => 10)
            end
            #@filter_tags = @community.get_tags_for_shared_entries

            # looking at stories from news feeds
            # tags have been specified
            if @tags && @tags.length > 0
                @news_entries = @community.get_entries(@tags, 
                                            :limit => ENTRIES_PER_PAGE,
                                            :offset => (ENTRIES_PER_PAGE * (@page - 1)))
                # unflitered (all entries)
            else
                @news_entries = @community.get_entries(nil, :limit => 20)
            end
            @filter_tags = @community.get_tags_for_feed_entries(@tags, :limit=>50)
            
            
            user_roles = @community.get_roles_for_user(user_id)
            if user_roles.size > 0
                @can_edit = user_roles.any? {|item| item["role_id"].to_i <= Community::ROLE_CONTRIBUTOR }
            else
                @can_edit = false
            end
            
            @members = @community.users.find(:all, :limit=>50, :order=>" communities_users.created_at DESC ")
            
            @community_tags = @community.get_tags_for_shared_entries(nil, :limit=>50)
            
        end
    end
    
    #############################################################
    # renders a tag cloud containing the tags applied to all entries
    # shared to all communities
    def community_tags
        @tag_filter = params[:tags]
        @tags = Entry.get_tags_for_shared_entries
        render(:partial => "community/tag_filter", :layout => false)
    end
    
    #############################################################
    # renders communities that use specifried tags
    def communities_that_use_tags
        tags = params[:tags]
        if (tags.size > 0)
            @communities = Community.get_communities_that_use_tags("all", tags, {:limit => 50})
        else
            @communities = @communities = Community.get_communities(current_user ? current_user.id : 0)
        end
        render(:partial => "community/thumbnail_list", :locals => {:communities => @communities, :layout => false, :tab => "popular"})
    end
    
    #############################################################
    # shows community entries tagged a certain way
    def entries_tagged
        show(params[:tags], "news")
#        @current_tab = "popular"
        render :template => "community/show"
    end
    
    #############################################################
    # show and allow editing of a group's feeds
    # NOTE: This method is not currently linked to from anyplace
    def feeds
        @community = Community.find_by_name(params[:name])
        @feeds_subscribed_to = @community.feeds.find(:all, :order => "feeds.title ASC") if @community != nil
        @feeds_not_subscribed_to = @community.get_feeds_not_subscribed_to if @community != nil
    end
    
    #############################################################
    # display a list of members in the current community
    def members
        @community = Community.find_by_name(params[:name])
        @members = @community.users
    end
    
    #############################################################
    # subscribes a community to a feed
    def subscribe
        community = Community.find_by_name(params[:name])
        community.subscribe_to_feed(params[:feed_id])
        redirect_to(:action => 'feeds', :name => params[:name])
    end
    
    #############################################################
    # unsubscribes a community to a feed
    def unsubscribe
        community = Community.find_by_name(params[:name])
        community.unsubscribe_from_feed(params[:feed_id])
        redirect_to(:action => 'feeds', :name => params[:name])
    end
    
    #############################################################
    # ajax - join the community
    def join_community
        if current_user
            @community = Community.find_by_name(params[:name])
            @user = User.find(current_user.id)
            community_user = CommunitiesUser.create(:user_id => @user.id, 
                                                    :community_id => @community.id, 
                                                    :role_id => Community::ROLE_MEMBER)
        end
        render :text => "<div class=\"belong-status\">You Belong</div>"
    end
    
    #############################################################
    # join the community (add a user)
    def join
        @community = Community.find_by_name(params[:name])
        if @community
            @user = User.find(current_user.id)
            if @user
                @community_users = CommunitiesUser.find(:all,
                                                        :conditions => ["user_id = :user_id and community_id = :community_id", 
                {:user_id => @user.id, :community_id => @community.id}])
                if @community_users.length <= 0
                    # add the user to the community
                    @community_user = CommunitiesUser.new(:community_id => @community.id, 
                                                          :user_id => @user.id,
                                                          :role_id => Community::ROLE_MEMBER)
                    
                    @community_user.save!
                    flash[:message] = "You have joined the group " + params[:name]
                else
                    flash[:message] = "You are already a member of the group " + params[:name]
                end
            end
        end
        redirect_to(:action => 'show', :name => params[:name])
    end
    
    #############################################################
    # leave the community (remove a user)
    def leave
        @community = Community.find_by_name(params[:name])
        if @community
            @community_users = CommunitiesUser.find(:all,
                                                    :conditions => ["user_id = :user_id and community_id = :community_id", 
            {:user_id => current_user.id, :community_id => @community.id}])
            @community_users.each do |community_user|
                community_user.destroy
                flash[:message] = "You have left the group " + params[:name]
            end
        end
        redirect_to(:action => 'show', :name => params[:name])
    end
    
    #############################################################
    # render the communities list of links (for AJAX request)
    # 
    # used by:
    #   nobody NOTE: will go in community home page
    def add_link
        @community = Community.find_by_name(params[:name])
        Community.add_link(@community.id,params[:uri],params[:title],@community.community_links.size + 1)
        @community_links = @community.community_links.find(:all, :order => 'position ASC')
        render(:partial => "render_links", :layout => false, :locals => {:links => @community_links})
    end
    
    ##########################################################
    # render for ajax the list of entries
    def find_entries
        
        good_to_go = false
        message = ""
        
        @page = params[:page]
        if nil == @page
            @page = 0
        end
        @page = @page.to_i
        
        @community = Community.find(params[:id])
        
        if params[:tags]
            @tags = params[:tags]
            @entries = @community.get_entries( @tags, 
                                              :limit => ENTRIES_PER_PAGE,
                                              :offset => (ENTRIES_PER_PAGE * (@page)))
            if @entries.length > 0
                good_to_go = true            
            else
                message = "Could not find any entries tagged #{@tags}."
            end                                     
        else
            @entries = Entry.get_entries_from_community_feeds(@community.id, 
                                                :limit => ENTRIES_PER_PAGE,
                                                :offset => (ENTRIES_PER_PAGE * (@page)))
            if @entries.length > 0
                good_to_go = true            
            else
                message = "Could not find any entries."
            end
        end
        
        if good_to_go
            render :partial => "feed/entries_tagged", :object => @entries, :layout => false, 
            :locals => {:tags => @tags, :id => @community.id, :page => @page, :service_id => @service.id}
        else
            render :text => message
        end
        
    end
    
    ##########################################################
    # handle ajax request to reorder links
    def order_links
        params[:group_links].each_with_index { |id,idx| CommunityLink.update(id, :position => idx) }
        render :layout => false, :text => 'Updated sort order'
    end
    
    ##########################################################
    # handle ajax request to display popular entries
    def popular_entries
        community_id = params[:community_id]
        if community_id == "0"
            @entries = Entry.stories_from_my_groups(current_user.id)
        else
            @entries = Entry.popular_stories_from_group(current_user.id,community_id,10)
        end 
        
        render(:layout => false, :partial => 'entry', :collection => @entries, :locals => {:show_entry_expander => false, :show_published_date => false, :show_feed_title => false, :community_id => community_id.to_i })
    end
    
    ##########################################################
    # vote a story up or down
    def vote_story(vote)
        community_id = params[:community_id]
        story_id = params[:story_id]
        community_entry = CommunitiesEntry.find_by_entry_id_and_community_id(story_id, community_id)
        CommunitiesEntriesVote.create(:communities_entry_id => community_entry.id, :user_id => current_user.id, :vote => vote)
        number_of_votes = community_entry.number_of_votes
        render :layout => false, :partial => "votes", :locals => {:votes => number_of_votes}
    end
    
    ##########################################################
    # vote a story up
    def vote_story_up
        vote_story 1
    end
    
    ##########################################################
    # vote a story up
    def vote_story_down
        vote_story(-1)
    end
end
