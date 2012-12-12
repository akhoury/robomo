class CreateTicketLinks < ActiveRecord::Migration
  def change
    create_table :ticket_links do |t|
      t.integer :ticket_id
      t.integer :linked_ticket_id
      
      t.timestamps
    end
  end
end
