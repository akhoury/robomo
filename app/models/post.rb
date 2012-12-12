class Post < ActiveRecord::Base
  belongs_to :ticket, :counter_cache => true
  has_many :assets, :dependent => :destroy
  accepts_nested_attributes_for :assets, :allow_destroy => true

  belongs_to :creator, :class_name => 'User'

  validates_presence_of :body, :creator

  after_create :send_notification

  after_save :touch_ticket

  def send_notification
    mail BugsMailer.thread_update(self)
    mail.deliver if mail.to_addrs.present?
  end

  def touch_ticket
    ticket.update_attributes(:last_post_at => Time.now, :last_modified_user => creator)
    ticket.set_time_to_first_reply if ticket.time_to_first_reply_in_seconds.blank?
  end
end
