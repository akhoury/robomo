class AddSprintTagToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :sprint_tag, :string
  end
end
