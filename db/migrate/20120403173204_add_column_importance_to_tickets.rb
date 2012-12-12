class AddColumnImportanceToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :importance, :integer
  end
end
