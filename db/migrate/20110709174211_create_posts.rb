class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :ticket

      t.string :creator
      t.text :body

      t.timestamps
    end

    add_index :posts, :ticket_id
  end
end
