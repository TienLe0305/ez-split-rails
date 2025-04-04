class User < ApplicationRecord
  has_many :expenses, foreign_key: :payer_id
  has_many :participants
  has_many :participated_expenses, through: :participants, source: :expense
  
  validates :name, presence: true
  
  # Add bank information attributes
  attribute :bank_account
  attribute :bank_name
end 