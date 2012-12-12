class CreateCcUsers < ActiveRecord::Migration
  def change
    create_table :cc_users do |t|
      t.references :user
      t.references :ticket

      t.timestamps
    end
  end
end
