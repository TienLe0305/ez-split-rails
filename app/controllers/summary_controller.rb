class SummaryController < ApplicationController
  # GET /api/summary
  def index
    # Calculate user summary
    @user_summary = calculate_user_summary
    
    # Calculate transactions needed to settle debts
    @transactions = calculate_transactions
    
    render json: {
      userSummary: @user_summary,
      transactions: @transactions
    }
  end
  
  # GET /api/summary/expense/:expense_id
  def expense_summary
    @expense = Expense.includes(:payer, participants: :user).find(params[:expense_id])
    
    # Get the payment statuses for this expense
    @payment_statuses = PaymentStatus.where(expense_id: @expense.id)
                                     .includes(:from_user, :to_user)
    
    # Calculate transactions for this expense
    @transactions = calculate_expense_transactions(@expense)
    
    render json: {
      expense: @expense,
      payment_statuses: @payment_statuses,
      transactions: @transactions
    }
  end
  
  # GET /api/summary/expenses-with-status
  def expenses_with_status
    @expenses = Expense.all.includes(:payer)
    
    # For each expense, count completed and pending payments
    @expenses_with_status = @expenses.map do |expense|
      payment_statuses = PaymentStatus.where(expense_id: expense.id)
      completed_count = payment_statuses.where(status: 'completed').count
      pending_count = payment_statuses.where(status: 'pending').count
      
      {
        id: expense.id,
        name: expense.name,
        amount: expense.amount,
        payer: expense.payer,
        created_at: expense.created_at,
        completed_count: completed_count,
        pending_count: pending_count,
        is_fully_settled: pending_count == 0 && completed_count > 0
      }
    end
    
    render json: @expenses_with_status
  end
  
  # GET /api/summary/expenses-transactions
  def expenses_transactions
    @expenses = Expense.all.includes(:payer)
    
    @expenses_transactions = @expenses.map do |expense|
      transactions = calculate_expense_transactions(expense)
      payment_statuses = PaymentStatus.where(expense_id: expense.id)
                                     .includes(:from_user, :to_user)
      
      {
        expense: {
          id: expense.id,
          name: expense.name,
          amount: expense.amount,
          payer: expense.payer,
          created_at: expense.created_at
        },
        transactions: transactions,
        payment_statuses: payment_statuses
      }
    end
    
    render json: @expenses_transactions
  end
  
  # POST /api/summary/payment/:payment_id
  def update_payment
    @payment = PaymentStatus.find(params[:payment_id])
    
    if params[:status] == 'completed'
      @payment.status = 'completed'
      @payment.paid_at = Time.now
    else
      @payment.status = 'pending'
      @payment.paid_at = nil
    end
    
    if @payment.save
      render json: @payment
    else
      render json: { error: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
  
  def calculate_user_summary
    users = User.all
    
    user_summary = users.map do |user|
      # Calculate how much this user has paid (as a payer)
      paid = Expense.where(payer_id: user.id).sum(:amount)
      
      # Calculate how much this user has spent (as a participant)
      spent = Participant.where(user_id: user.id).sum(:amount)
      
      # Calculate how much this user has received (completed payments)
      received = PaymentStatus.where(to_user_id: user.id, status: 'completed').sum(:amount)
      
      # Calculate how much this user is waiting to receive (pending payments)
      pending = PaymentStatus.where(to_user_id: user.id, status: 'pending').sum(:amount)
      
      # Calculate balance
      balance = paid - spent
      
      {
        id: user.id,
        name: user.name,
        paid: paid,
        spent: spent,
        received: received,
        pending: pending,
        balance: balance
      }
    end
    
    user_summary
  end
  
  def calculate_transactions
    # Get all users and their expenses
    users = User.all
    user_balances = {}
    
    # Calculate each user's balance
    users.each do |user|
      paid = Expense.where(payer_id: user.id).sum(:amount)
      spent = Participant.where(user_id: user.id).sum(:amount)
      balance = paid - spent
      
      user_balances[user.id] = {
        id: user.id,
        name: user.name,
        balance: balance
      }
    end
    
    # Separate users who are owed money (positive balance) and who owe money (negative balance)
    creditors = user_balances.values.select { |u| u[:balance] > 0 }.sort_by { |u| -u[:balance] }
    debtors = user_balances.values.select { |u| u[:balance] < 0 }.sort_by { |u| u[:balance] }
    
    # Calculate transactions to settle debts
    transactions = []
    
    debtors.each do |debtor|
      debt_remaining = -debtor[:balance].abs
      
      while debt_remaining > 0 && !creditors.empty?
        creditor = creditors.first
        credit_remaining = creditor[:balance]
        
        # Calculate transaction amount
        amount = [debt_remaining, credit_remaining].min
        
        # Create a transaction
        transactions << {
          from: debtor[:id],
          to: creditor[:id],
          fromName: debtor[:name],
          toName: creditor[:name],
          amount: amount
        }
        
        # Update remaining amounts
        debt_remaining -= amount
        creditor[:balance] -= amount
        
        # If creditor is fully paid, remove from list
        if creditor[:balance] <= 0
          creditors.shift
        end
      end
    end
    
    transactions
  end
  
  def calculate_expense_transactions(expense)
    payer = expense.payer
    participants = expense.participants.includes(:user)
    
    # Create payment status records if they don't exist
    participants.each do |participant|
      # Skip if participant is the payer
      next if participant.user_id == payer.id
      
      # Skip if payment amount is zero
      next if participant.amount <= 0
      
      # Create or find payment status
      payment_status = PaymentStatus.find_or_create_by(
        expense_id: expense.id,
        from_user_id: participant.user_id,
        to_user_id: payer.id
      ) do |ps|
        ps.amount = participant.amount
        ps.status = 'pending'
      end
    end
    
    # Get all payment statuses for this expense
    payment_statuses = PaymentStatus.where(expense_id: expense.id)
                                   .includes(:from_user, :to_user)
    
    # Map payment statuses to transactions
    transactions = payment_statuses.map do |ps|
      {
        id: ps.id,
        from: ps.from_user_id,
        to: ps.to_user_id,
        fromName: ps.from_user.name,
        toName: ps.to_user.name,
        amount: ps.amount,
        status: ps.status,
        paid_at: ps.paid_at
      }
    end
    
    transactions
  end
end 