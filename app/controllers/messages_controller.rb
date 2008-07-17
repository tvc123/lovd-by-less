class MessagesController < ApplicationController

    before_filter :can_send, :only => :create
    before_filter :setup

    def index
        @message = Message.new
        if current_user.received_messages.empty? && current_user.has_network?
            flash[:notice] = 'You have no mail in your inbox.  Try sending a message to someone.'
            redirect_to new_user_message_path(current_user) and return
        end
    end

    def create
        @message = current_user.sent_messages.create(params[:message]) 

        respond_to do |format|
            if @message.new_record?
                format.js do
                    render :update do |page|
                        page.alert @message.errors.to_s
                    end
                end
            else
                format.js do
                    render :update do |page|
                        page.alert "Message sent."
                        page << "jQuery('#message_subject, #message_body').val('');"
                        page << "tb_remove()"
                    end
                end
            end
        end
    end

    def new
        @message = Message.new
        respond_to do |format|
            format.html
        end
    end


    def sent
        @message = Message.new
    end

    def show
        @message = current_user.sent_messages.find params[:id] rescue nil
        @message ||= current_user.received_messages.find params[:id] rescue nil
        @to_list = [@message.sender]
        respond_to do |format|
            format.html
        end
    end

    protected
    def allow_to
        super :user, :all => true
    end

    def can_send
        render :update do |page|
            page.alert "Sorry, you can't send messages."
        end unless current_user.can_send_messages
    end
    
    def setup
        @user = User.find_by_login(params[:user_id]) || current_user
    end

end
