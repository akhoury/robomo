class SimplifyTickets < ActiveRecord::Migration
  def up
    remove_column :tickets, :url
    remove_column :tickets, :reproduction_steps             
    remove_column :tickets, :observed_results               
    remove_column :tickets, :expected_results               
    remove_column :tickets, :importance                     
  end

  def down
    add_column :tickets, :url, :string, :limit => 500
    add_column :tickets, :reproduction_steps, :string             
    add_column :tickets, :observed_results, :string
    add_column :tickets, :expected_results, :string
    add_column :tickets, :importance, :integer
  end
end
