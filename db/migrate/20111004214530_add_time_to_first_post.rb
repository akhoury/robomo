class AddTimeToFirstPost < ActiveRecord::Migration
  def up
    add_column :tickets, :time_to_first_reply_in_seconds, :integer

    Ticket.reset_column_information
    Ticket.all.each do |ticket|
      if ticket.posts.any?
        seconds = ticket.posts.order("created_at asc").first.created_at.to_i - ticket.created_at.to_i
        ticket.update_attribute(:time_to_first_reply_in_seconds, seconds)
      end
    end
  end

  def down
    remove_column :tickets, :time_to_first_reply_in_seconds
  end
end
