class AddTicketForeignKeyToCcUser < ActiveRecord::Migration
  def change
    add_foreign_key :cc_users, :tickets
  end
end
