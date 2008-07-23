class Users::GroupsController < ApplicationController
    
    skip_filter :login_required, :only => [:index]
    before_filter :setup
    
    # if a user exists in the request show groups for that user.  If not then show all groups
    def index
        
        @groups = @user.groups.paginate(:page => @page, :per_page => @per_page)
       
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @groups }
        end
    end

    def new
        @group = Group.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @group }
        end
    end

    def create
        @group = Group.new(params[:group])
        @group.creator = @user
        
        respond_to do |format|
            if @group.save
                
                @membership = Membership.new(:role => :manager)
                @membership.user = @user
                @membership.group = @group
                
                if @membership.save                
                    flash[:notice] = 'Group was successfully created.'
                    format.html { redirect_to(@group) }
                    format.xml  { render :xml => @group, :status => :created, :location => @group }
                else
                    flash[:notice] = 'There was a problem creating the group.  Please try again.'
                    format.html { render :action => "new" }
                    format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
                end
                
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
            end
        end
    end
    
    private
    
    def setup
        @user = User.find_by_login(params[:user_id])
        if !@user
            flash[:notice] = "There was a problem with the group.  Please try again."
            permission_denied 
        end
    end
    
end
