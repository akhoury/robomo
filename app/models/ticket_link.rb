class TicketLink < ActiveRecord::Base
  
  belongs_to :ticket
  belongs_to :linked_ticket, :class_name => 'Ticket'
  
  validates_presence_of :linked_ticket_id, :ticket_id
  validate :validate_unique_link
  
  def validate_unique_link
    exists_a = TicketLink.exists? ['linked_ticket_id = ? AND ticket_id = ? AND id != ?', linked_ticket_id, ticket_id, (id || -1)]
    exists_b = TicketLink.exists? ['linked_ticket_id = ? AND ticket_id = ? AND id != ?', ticket_id, linked_ticket_id, (id || -1)]
    errors.add(:ticket_id, 'duplicate') if exists_a || exists_b
  end
     
end