class Duplication < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :duplicate, :class_name => "Ticket"
end

