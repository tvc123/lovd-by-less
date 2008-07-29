class GroupsController < ApplicationController
    
    skip_filter :login_required, :only => [:index, :show]
    
    def index        
        @groups = Group.find(:all).paginate(:page => @page, :per_page => @per_page)
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @groups }
        end
    end

    def show
        @group = Group.find(params[:id])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @group }
        end
    end

    def edit
        @group = Group.find(params[:id])
    end

    def update
        @group = Group.find(params[:id])
        respond_to do |format|
            if @group.update_attributes(params[:group])
                flash[:notice] = 'Group was successfully updated.'
                format.html { redirect_to(@group) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
        @group = Group.find(params[:id])
        @group.destroy
        respond_to do |format|
            format.html { redirect_to(groups_url) }
            format.xml  { head :ok }
        end
    end
    
    def delete_icon
        @group = Group.find(params[:id])
        respond_to do |format|
            @group.update_attribute :icon, nil
            format.js {render :update do |page| page.visual_effect 'Puff', 'group_icon_picture' end  }
        end      
    end
        
end
