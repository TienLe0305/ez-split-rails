class CreatePaymentStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_statuses do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :from_user, null: false, foreign_key: { to_table: :users }
      t.references :to_user, null: false, foreign_key: { to_table: :users }
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :status, default: 'pending', null: false
      t.datetime :paid_at
      
      t.timestamps
    end
    
    add_index :payment_statuses, [:from_user_id, :to_user_id, :expense_id], unique: true, name: 'idx_payment_statuses_unique'
  end
end 