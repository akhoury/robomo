class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :creator
      t.string :subject
      t.string :url, :limit => 500

      t.text :summary
      t.text :description
      t.text :reproduction_steps
      t.text :observed_results
      t.text :expected_results
      t.integer :importance

      t.timestamps
    end
  end
end
