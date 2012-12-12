class AddStateFieldsToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :state, :string, :default => 'pending'
  end
end
