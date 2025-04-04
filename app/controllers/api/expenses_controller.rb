module Api
  class ExpensesController < ApplicationController
    # GET /api/expenses
    def index
      @expenses = Expense.all.includes(:payer, participants: :user)
      render json: @expenses
    end
    
    # GET /api/expenses/:id
    def show
      @expense = Expense.includes(:payer, participants: :user).find(params[:id])
      render json: @expense
    end
    
    # POST /api/expenses
    def create
      ActiveRecord::Base.transaction do
        @expense = Expense.new(expense_params)
        @expense.save!
        
        # Create participants
        create_participants
        
        render json: @expense, status: :created
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
    
    # PUT /api/expenses/:id
    def update
      ActiveRecord::Base.transaction do
        @expense = Expense.find(params[:id])
        @expense.update!(expense_params)
        
        # Update participants by removing existing ones and creating new ones
        @expense.participants.destroy_all
        create_participants
        
        render json: @expense
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
    
    # DELETE /api/expenses/:id
    def destroy
      @expense = Expense.find(params[:id])
      @expense.destroy
      head :no_content
    end
    
    private
    
    def expense_params
      params.require(:expense).permit(:name, :amount, :payer_id)
    end
    
    def create_participants
      participants_params = params.require(:participants)
      participants_params.each do |participant_params|
        @expense.participants.create!(
          user_id: participant_params[:user_id],
          amount: participant_params[:amount]
        )
      end
    end
  end
end 