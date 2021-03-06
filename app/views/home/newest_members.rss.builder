
xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title "#{GlobalConfig.application_url_name} Newest Member Feed"
    xml.link GlobalConfig.application_url
    xml.description "This feed will quickly show who has recently signed up for #{GlobalConfig.application_url_name}"
    xml.language 'en-us'
    new_members.each do |newest_member|
      xml.item do
        xml.title "New member of #{GlobalConfig.application_url_name}: #{newest_member.f}"
        xml.description "See #{newest_member.f}'s #{link_to('page', profile_url(newest_member))}"
        xml.author ""
        xml.pubDate newest_member.created_at
        xml.link profile_url(newest_member)
        xml.guid profile_url(newest_member)
      end
    end
  end
end