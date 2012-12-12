module ApplicationHelper
  def notification_toggle_link
    return "" unless logged_in?
    link_text = if current_user.receive_all_emails?
                  "All Emails"
                else
                  "Only My Threads"
                end
    link_to(link_text, '/toggle_notifications')
  end

  def asset_link(asset, opts={})
    if asset.content_content_type =~ /image/
      # Must use content_tag vs. image_tag because the Asset Pipeline is an over-engineered POS
      content_tag(:img, '', opts.merge(:src => asset.content.url(:thumb), :href => asset.content.url(:original), :class => 'lightview'))
    else
      link_to(asset.content_file_name, asset.content.url(:original))
    end
  end

  def smart_time time
    content_tag(:time, :datetime => time.iso8601, :title => time.iso8601) do
      if Time.now - time >= 1.day
        time.strftime('%m/%d/%Y')
      else
        distance_of_time_in_words(Time.now, time) << ' ago'
      end
    end
  end
end
