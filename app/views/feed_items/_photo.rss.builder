xml = xml_instance unless xml_instance.nil?
xml.item do
  p = feed_item.item
  xml.title "#{p.user.f} uploaded a photo"
  xml.description p.caption.blank? ? 'No caption provided' : sanitize(textilize(p.caption))
  xml.author "#{p.user.email} (#{p.user.f})"
  xml.pubDate p.updated_at
  xml.link user_photo_url(p.user, p)
  xml.guid user_photo_url(p.user, p)
end