class User < ActiveRecord::Base
  scope :to_receive_all_emails, where( arel_table[:admin].eq(true).or(arel_table[:receive_all_emails].eq(true)) )

  def self.find_or_create(params)
    User.find_by_email(params[:email]) || User.create(params)
  end

  def can_edit?(ticket)
    self.admin? || self == ticket.creator
  end

  def toggle_notifications!
    self.update_attributes(:receive_all_emails => !self.receive_all_emails)
  end
end
