module ApplicationHelper
    require 'digest/sha1'
    require 'net/http'
    require 'uri'

    def icon object, size = :small, img_opts = {}
        return "" if object.nil?
        
        options = {:size => size, :file_column_version => size }
        
        if object.is_a?(User)
            img_opts = {:title => object.full_name, :alt => object.full_name, :class => size}.merge(img_opts)
            link_to(avatar_tag(object, {:size => size, :file_column_version => size }, img_opts), profile_path(object))
        elsif object.is_a?(Group)                     
            url = icon_url(object, options)
            return '' if url.empty?
            html_options = {:title => object.name, :alt => object.name, :class => size}.merge(img_opts)
            link_to(image_tag(url, html_options), group_path(object))
        end
    
    end     
    
    def icon_url(object, options)
        field = options.delete(:file_column_field) || 'icon'
        return '' if field.nil? || object.send(field).nil?
        options = options[:file_column_version] || options
        url_for_image_column(object, 'icon', options)
    end
          
    def is_me?(user)
        user == current_user
    end

    def custom_form_for(record_or_name_or_array, *args, &proc) 
        options = args.detect { |argument| argument.is_a?(Hash) } 
        if options.nil? 
            options = {:builder => CustomFormBuilder} 
            args << options 
        end 
        options[:builder] = CustomFormBuilder unless options.nil? 
        form_for(record_or_name_or_array, *args, &proc) 
    end
    
    def less_form_for name, *args, &block
        options = args.last.is_a?(Hash) ? args.pop : {}
        options = options.merge(:builder=>LessFormBuilder)
        args = (args << options)
        form_for name, *args, &block
    end

    def less_remote_form_for name, *args, &block
        options = args.last.is_a?(Hash) ? args.pop : {}
        options = options.merge(:builder=>LessFormBuilder)
        args = (args << options)
        remote_form_for name, *args, &block
    end

    def display_standard_flashes(message = 'There were some problems with your submission:')
        if flash[:notice]
            flash_to_display, level = flash[:notice], 'notice'
        elsif flash[:warning]
            flash_to_display, level = flash[:warning], 'warning'
        elsif flash[:error]
            level = 'error'
            if flash[:error].instance_of?( ActiveRecord::Errors) || flash[:error].is_a?( Hash)
                flash_to_display = message
                flash_to_display << activerecord_error_list(flash[:error])
            else
                flash_to_display = flash[:error]
            end
        else
            return
        end
        content_tag 'div', flash_to_display, :class => "flash#{level}"
    end

    def activerecord_error_list(errors)
        error_list = '<ul class="error_list">'
        error_list << errors.collect do |e, m|
            "<li>#{e.humanize unless e == "base"} #{m}</li>"
        end.to_s << '</ul>'
        error_list
    end

    def inline_tb_link link_text, inlineId, html = {}, tb = {}
        html_opts = {
            :title => '',
            :class => 'thickbox'
            }.merge!(html)

        tb_opts = {
            :height => 300,
            :width => 400,
            :inlineId => inlineId
            }.merge!(tb)

            path = '#TB_inline'.add_param(tb_opts)
            link_to(link_text, path, html_opts)
    end

    def tb_video_link youtube_unique_path
        return if youtube_unique_path.blank?
        youtube_unique_id = youtube_unique_path.split(/\/|\?v\=/).last.split(/\&/).first
        p youtube_unique_id
        client = YouTubeG::Client.new
        video = client.video_by GlobalConfig.youtube_base_url+youtube_unique_id rescue return "(video not found)"
        id = Digest::SHA1.hexdigest("--#{Time.now}--#{video.title}--")
        inline_tb_link(video.title, h(id), {}, {:height => 355, :width => 430}) + %(<div id="#{h id}" style="display:none;">#{video.embed_html}</div>)
    end

    def is_controller?(controller, &block)
        if params[:controller] == controller
            content = capture(&block)
            concat(content, block.binding)
        end
    end
    
end
