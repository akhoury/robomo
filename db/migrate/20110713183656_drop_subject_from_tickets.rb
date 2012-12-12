class DropSubjectFromTickets < ActiveRecord::Migration
  def up
    remove_column :tickets, :subject
    change_column :tickets, :summary, :string, :limit => 1500
  end

  def down
    add_column :tickets, :subject, :string
    change_column :tickets, :summary, :text
  end
end
