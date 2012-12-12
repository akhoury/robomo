class ChangeCreatorToCreatorUserId < ActiveRecord::Migration
  def up
    remove_column :tickets, :creator
    add_column :tickets, :creator_id, :integer
    remove_column :posts, :creator
    add_column :posts, :creator_id, :integer

    execute "update tickets set creator_id = 1"
    execute "update posts set creator_id = 1"
  end

  def down
    remove_column :posts, :creator_id
    add_column :posts, :creator, :string
    remove_column :tickets, :creator_id
    add_column :tickets, :creator, :string
  end
end
