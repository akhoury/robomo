class AddReceiveAllEmailsFilterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_all_emails, :boolean, :default => false
  end
end
