Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # API Routes
  namespace :api do
    # Users routes
    resources :users
    
    # Expenses routes
    resources :expenses
    
    # Summary routes
    get 'summary', to: 'summary#index'
    get 'summary/expense/:expense_id', to: 'summary#expense_summary'
    get 'summary/expenses-with-status', to: 'summary#expenses_with_status'
    get 'summary/expenses-transactions', to: 'summary#expenses_transactions'
    post 'summary/payment/:payment_id', to: 'summary#update_payment'
  end
end
