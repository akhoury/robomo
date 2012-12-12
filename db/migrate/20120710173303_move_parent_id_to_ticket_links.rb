class MoveParentIdToTicketLinks < ActiveRecord::Migration
  class Ticket < ActiveRecord::Base
  end

  class TicketLink < ActiveRecord::Base
  end

  def up
    Ticket.find_each do |ticket|
      TicketLink.create(:ticket_id => ticket.id, :linked_ticket_id => ticket.parent_id)
    end
    remove_column :tickets, :parent_id
  end

  def down
    add_column :tickets, :parent_id, :integer
  end
end
