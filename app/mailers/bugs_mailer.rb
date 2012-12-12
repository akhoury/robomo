class BugsMailer < ActionMailer::Base
  PRODUCTS_AT = "products@patientslikeme.com"

  default :from => PRODUCTS_AT

  default_url_options[:host] = ::APPLICATION_URL

  def thread_update(post)
    @ticket = post.ticket
    recipients = recipients_for(post)
    @thread_link = ticket_path(@ticket, :only_path => false)
    @post = post
    mail(:subject => "New Post to #{@ticket.summary}",
         :to => recipients.map(&:email).join(","))
  end

  def new_ticket(ticket)
    @ticket = ticket
    recipients = recipients_for(ticket).map(&:email)
    @thread_link = ticket_path(@ticket, :only_path => false)
    mail(:subject => "New Idea: #{@ticket.summary}",
         :to => recipients.join(","))
  end

  private

  def recipients_for(obj)
    ticket = obj.instance_of?(Post) ? obj.ticket : obj
    ticket.unique_recipients - [obj.creator]
  end
end
