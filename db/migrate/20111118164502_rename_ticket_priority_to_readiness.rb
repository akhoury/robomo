class RenameTicketPriorityToReadiness < ActiveRecord::Migration
  def up
    rename_column :tickets, :priority, :readiness
  end

  def down
    rename_column :tickets, :readiness, :priority 
  end
end
