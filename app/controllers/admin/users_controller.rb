class Admin::UsersController < ApplicationController
    before_filter :search_results, :except => [:destroy]

    def index
        render
    end

    def update
        @user = User.find(params[:id])
        respond_to do |format|
            format.js do
                render :update do |page|
                    if is_me?(@user)
                        page << "message('You cannot deactivate yourself!');"
                    else
                        @user.toggle! :is_active
                        page << "message('User has been marked as #{@user.is_active ? 'active' : 'inactive'}');"
                        page.replace_html @user.dom_id('link'), (@user.is_active ? 'deactivate' : 'activate')
                    end
                end
            end
        end
    end

    private

    def search_results
        if params[:search]
            p = params[:search].dup
        else
            p = []
        end
        @results = User.search((p.delete(:q) || ''), p).paginate(:page => @page, :per_page => @per_page)
    end
end
