class AddParentTicketIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :parent_id, :integer
  end
end
