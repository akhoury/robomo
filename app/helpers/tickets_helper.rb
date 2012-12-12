module TicketsHelper
  def tag_link_attributes(tag)
    tags = (params[:tagged_with] || []) + [tag.name]
    params.merge({:tagged_with => tags}).reject{|k,v| k.to_s == 'page'}
  end

  def showing_ticket_numbers
    page_start = (@tickets.current_page - 1) * Ticket.default_per_page
    "#{page_start + 1}-#{page_start + @tickets.size}"
  end

  def json_user_hash
    User.all.inject({}){|h, u| h[u.name] = u.id; h}.to_json
  end

  def not_on_cc_list?
    !(User.to_receive_all_emails + @ticket.users_to_cc).include?(current_user)
  end


  def turnaround_report
    avg = Ticket.where("last_post_at is not null").limit(25).average(:time_to_first_reply_in_seconds)
    if avg
      content_tag :p, :id => 'response-time' do
        "Average time to first response over the last 25 tickets: ".html_safe +
        content_tag(:strong, distance_of_time_in_words(avg))
      end
    end
  end

  def state_filter_link(state)
    link_text = "#{formatted_state(state)} (#{Ticket.state(state).matching(params[:matching]).count})"
    content_tag :li, :class => (params[:state] == state ? 'yah' : nil) do
      link_to(link_text, "/tickets?state=#{state}&matching=#{params[:matching]}")
    end
  end

  def tag_cloud_word
    (params[:state] || (params[:scheduled] ? 'scheduled' : 'popular')).titleize
  end

  def formatted_state(state)
    state.titleize.gsub(/Resolved/, "Resolved: ")
  end

  # ACTION LINKS
  def ticket_resolve_link(resolution)
    if @ticket.send("can_#{resolution}?") && ((@ticket.pending? && current_user == @ticket.creator) || current_user.admin?)
      button_to(resolution.to_s.titleize, ticket_state_change_url(resolution),
                :class => resolution)
    end
  end
  
  def ticket_submitted_link
    ticket_link_for("submitted", "Submitted", "submitted")
  end
  
  def ticket_postpone_link
    ticket_link_for("postpone", "Postpone", "postpone")
  end
  
  def ticket_begin_work_link
    ticket_link_for("begin_work", "Begin Work", "begin_work")
  end

  def ticket_release_link
    ticket_link_for("release", "Release", "release")
  end

  def ticket_close_link
    ticket_link_for("close", "Close", "close")
  end
  
  def ticket_mark_estimated_link
    ticket_link_for("mark_estimated", "Mark Estimated", "mark_estimated")
  end

  def ticket_schedule_for_estimation_link
    ticket_link_for("schedule_for_estimation", "Schedule For Estimation", "schedule_for_estimation")
  end


  def ticket_link_for(transition, link_text, link_class)
    if @ticket.send("can_#{transition}?") && current_user.admin?
      button_to(link_text, ticket_state_change_url(transition), :class => link_class)
    end
  end

  def ticket_state_change_url(action)
    "/tickets/#{@ticket.id}/change_state?transition=#{action}"
  end
end
