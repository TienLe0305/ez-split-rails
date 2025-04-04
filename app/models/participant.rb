class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :expense
  
  validates :user_id, presence: true
  validates :expense_id, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end 