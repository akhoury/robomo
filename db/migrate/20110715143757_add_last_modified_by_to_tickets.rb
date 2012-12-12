class AddLastModifiedByToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :last_modified_by, :integer
  end
end
