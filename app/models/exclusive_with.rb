class ExclusiveWith < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :exclusion, :class_name => "Ticket"
end
