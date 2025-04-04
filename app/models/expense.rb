class Expense < ApplicationRecord
  belongs_to :payer, class_name: 'User'
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payer_id, presence: true
  
  def as_json(options = {})
    super(options.merge(
      include: {
        payer: { only: [:id, :name] },
        participants: {
          include: {
            user: { only: [:id, :name] }
          }
        }
      }
    ))
  end
end 