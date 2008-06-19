module FeedItemsHelper
  def x_feed_link feed_item
    link_to_remote image_tag('delete.png', :class => 'png', :width=>'12', :height=>'12'), :url => user_feed_item_path(current_user, feed_item), :method => :delete
  end
  
  
  def commentable_text comment, in_html = true
    parent = comment.commentable
    case parent.class.name
    when 'User'
      "#{link_to_if in_html, comment.user.f, comment.user} wrote a comment on #{link_to_if in_html, parent.f+'\'s', profile_path(parent)} wall"
    when 'Blog'
      "#{link_to_if in_html, comment.user.f, comment.user} commented on #{link_to_if in_html, h(parent.title), user_blog_path(parent.user, parent)}"
    end
  end
end
