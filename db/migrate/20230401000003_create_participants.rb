class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :expense, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      
      t.timestamps
    end
    
    add_index :participants, [:user_id, :expense_id], unique: true
  end
end 