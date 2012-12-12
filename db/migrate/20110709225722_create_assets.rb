class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :ticket
      t.references :post

      t.string :content_file_name
      t.string :content_content_type
      t.integer :content_file_size

      t.timestamps
    end
  end
end
