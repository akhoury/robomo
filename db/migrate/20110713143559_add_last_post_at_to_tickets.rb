class AddLastPostAtToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :last_post_at, :datetime
  end
end
