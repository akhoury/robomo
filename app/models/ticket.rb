class Ticket < ActiveRecord::Base
  acts_as_taggable
  scope :state, proc {|state| state.present? ? where(:state => state) : nil}
  scope :with_creator, proc {|ignore| includes(:creator) }
  scope :scheduled, where("sprint_tag != '' AND state IN ('submitted','scheduled_for_estimation','estimated','in_progress')")
  paginates_per 50

  has_many :duplications
  has_many :duplicates, :through => :duplications
  has_many :inverse_duplications, :class_name => "Duplication", :foreign_key => "duplicate_id"
  has_many :inverse_duplicates, :through => :inverse_duplications, :source => :ticket
  def duplicate_tickets
    duplicates + inverse_duplicates
  end

  has_many :exclusive_withs
  has_many :exclusions, :through => :exclusive_withs
  has_many :inverse_exclusive_withs, :class_name => "ExclusiveWith", :foreign_key => "exclusion_id"
  has_many :inverse_exclusions, :through => :inverse_exclusive_withs, :source => :ticket

  has_many :ticket_links
  has_many :linked_ticket_ids, :through => :ticket_links, :source => :ticket
  has_many :ticket_ids, :through => :ticket_links, :source => :ticket
   
  def exclusive_with_tickets
    exclusions + inverse_exclusions
  end

  def linked_tickets
    Ticket.select("tl.id as ticket_link_id, tickets.id, tickets.summary ").
      joins("join ticket_links tl on tl.ticket_id = tickets.id or tl.linked_ticket_id = tickets.id").
      where("tl.ticket_id = :id or tl.linked_ticket_id = :id and tickets.id != :id", { :id => self.id }).
    delete_if { |t| t.id == self.id }.uniq
  end

  scope :sorted, proc {|sort_col, direction|
    sort_col = case sort_col
    when 'creator'
      "users.name"
    when 'importance'
      "coalesce(importance, 0)"
    when *(self.attribute_names)
      sort_col
    else
      sort_col = "case when updated_at > coalesce(last_post_at, '2001-01-01') then updated_at else last_post_at end"
    end
    direction = 'desc' unless direction == 'asc'

    if sort_col =~ /users/
      joins(:creator).order("#{sort_col} #{direction}")
    else
      order("#{sort_col} #{direction}")
    end
  }

  state_machine :state, :initial => :submitted do
    state :submitted
    state :postponed
    state :scheduled_for_estimation
    state :estimated
    state :in_progress
    state :released
    state :closed
    
    after_transition do |ticket, transition|
      StateChange.create!(:state => ticket.state, :ticket => ticket,
                          :user => ticket.last_modified_user, :changed_at => ticket.updated_at)
    end

    event :submitted do
      transition all - [:released, :submitted] => :submitted
    end
    
    event :postpone do
      transition all - [:released, :postponed] => :postponed
    end
    
    event :schedule_for_estimation do
      transition all - [:released, :scheduled_for_estimation] => :scheduled_for_estimation
    end

    event :mark_estimated do
      transition all - [:released, :estimated] => :estimated
    end

    event :begin_work do
      transition all - [:in_progress, :released] => :in_progress
    end

    event :release do
      transition all - [:released] => :released
    end
    
    event :close do
      transition all - [:closed] => :closed
    end
  end

  def self.states
    state_machines[:state].states.map(&:value)
  end

  has_many :posts
  has_many :assets, :dependent => :destroy
  has_many :state_changes, :dependent => :destroy
  has_many :cc_users, :dependent => :destroy
  accepts_nested_attributes_for :cc_users, :allow_destroy => true

  after_create :send_notification

  accepts_nested_attributes_for :assets, :allow_destroy => true

  belongs_to :creator, :class_name => 'User'
  belongs_to :last_modified_user, :class_name => 'User', :foreign_key => 'last_modified_by'

  validates_presence_of :summary, :description, :creator
  validates_inclusion_of :importance, :in => [nil,1,2,3,4]

  SEARCHABLE_FIELDS = :summary, :description

  def self.readiness_states
    [[1, "Idea:  This is an idea. Maybe good. Maybe bad. I am simply recording it for posterity."],
     [2, "Started: Maybe we have a sense of requirements of this. But someone has thought about it enough to start moving it forward."],
     [3, "Getting there: We've started talking about this and maybe even have an idea how to implement it. But may need designs or user testing or external approval to move forward."],
     [4, "Pretty close: There are some open questions, but we know enough to be able to estimate this and answer questions as we go."],
     [5, "Punch it, Chewy! This is well-understood, has designs (or doesn't need them) and is ready to be implemented now."]]
  end

  def readiness_word
    readiness ? Ticket.readiness_states[readiness - 1][1] : ""
  end

  def short_readiness_word
    readiness ? readiness_word.split(/[:!]/).first : ""
  end
 
  def self.importances
    [[1, "Nice to have"], [2, "Low importance"], [3, "Medium importance"], [4, "High importance"]]
  end

  def importance_word
    if importance
      Ticket.importances[importance - 1][1]
    else
      ""
    end
  end

  def short_importance_word
    importance_word.split(/:|importance/).first
  end

  def self.matching(query)
    conditions = SEARCHABLE_FIELDS.inject(nil) do |node, field|
      matcher = arel_table[field].matches("%#{query}%")
      node ? node.or(matcher) : matcher
    end

    where(conditions)
  end

  def last_update
    [updated_at, (last_post_at || 1.year.ago)].max
  end

  def thread_members
    ([self.creator] + self.posts.map(&:creator)).compact.uniq
  end

  def users_to_cc
    cc_users.map(&:user)
  end

  def unique_recipients
    (thread_members + users_to_cc + User.to_receive_all_emails).uniq
  end

  def send_notification
    mail = BugsMailer.new_ticket(self)
    mail.deliver if mail.to_addrs.present?
  end

  def set_time_to_first_reply
    unless self.time_to_first_reply_in_seconds
      seconds = Time.now.to_i - self.created_at.to_i
      self.update_attribute(:time_to_first_reply_in_seconds, seconds)
    end
  end

  def events
    (self.posts + self.state_changes).reject{|e| e.created_at.blank? }.sort_by{|e| e.created_at}
  end
end
