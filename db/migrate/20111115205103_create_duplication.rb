class CreateDuplication < ActiveRecord::Migration
  def up
    create_table :duplications do |t|
      t.integer :ticket_id
      t.integer :duplicate_id
    end
  end

  def down
    drop_table :duplications
  end
end
