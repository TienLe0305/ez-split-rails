class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :bank_account
      t.string :bank_name
      
      t.timestamps
    end
  end
end 