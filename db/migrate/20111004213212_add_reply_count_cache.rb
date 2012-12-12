class AddReplyCountCache < ActiveRecord::Migration
  def up
    add_column :tickets, :posts_count, :integer, :default => 0

    Ticket.reset_column_information
    Ticket.all.each do |t|
      Ticket.update_counters t.id, :posts_count => t.posts.count
    end
  end

  def down
    remove_column :tickets, :posts_count
  end
end
