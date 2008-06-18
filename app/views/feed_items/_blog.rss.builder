xml = xml_instance unless xml_instance.nil?
xml.item do
  b = feed_item.item
  xml.title "#{b.user.f} blogged #{time_ago_in_words b.created_at} #{b.title}"
  xml.description sanitize(textilize(b.body))
  xml.author "#{b.user.email} (#{b.user.f})"
  xml.pubDate b.updated_at
  xml.link user_blog_url(b.user, b)
  xml.guid user_blog_url(b.user, b)
end