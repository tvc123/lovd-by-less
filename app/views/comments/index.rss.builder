#locals
comments ||= @comments
parent ||= @parent

xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0"){
  xml.channel do
    xml.title "Wall to wall with #{@user.f}"
    xml.link SITE
    xml.description "Wall to wall with #{@user.f} on #{SITE_NAME}"
    xml.language 'en-us'
    comments.each do |c|
      xml.item do
        xml.title commentable_text(c, false)
        xml.link @user_feed_item_url(@user, c)
        xml.guid @user_feed_item_url(@user, c)
        xml.description sanitize(textilize(c.comment))
        xml.author "#{c.@user.email} (#{c.@user.f})"
        xml.pubDate c.updated_at
      end
    end
  end
}