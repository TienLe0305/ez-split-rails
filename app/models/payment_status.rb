class PaymentStatus < ApplicationRecord
  belongs_to :expense
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'
  
  validates :expense_id, presence: true
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  
  # Status can be 'pending' or 'completed'
  validates :status, presence: true, inclusion: { in: ['pending', 'completed'] }
end 