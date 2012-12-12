class CreateExclusiveWith < ActiveRecord::Migration
  def up
    create_table :exclusive_withs do |t|
      t.integer :ticket_id
      t.integer :exclusion_id
    end
  end

  def down
    drop_table :exclusive_withs 
  end
end
