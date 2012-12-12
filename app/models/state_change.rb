class StateChange < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user

  validates_inclusion_of :state, :in => Ticket.states

end
