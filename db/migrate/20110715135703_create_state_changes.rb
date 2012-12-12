class CreateStateChanges < ActiveRecord::Migration
  def change
    create_table :state_changes do |t|
      t.string :state, :null => false
      t.datetime :changed_at
      t.integer :user_id
      t.integer :ticket_id

      t.timestamps
    end
  end
end
