# EzSplitPVN Rails Backend

This is the Ruby on Rails API backend for the EzSplitPVN application, migrated from the original Express.js backend.

## Setup

1. Install dependencies:
```bash
bundle install
```

2. Create a `.env` file in the root directory with the following variables:
```
PORT=5000
DATABASE_USERNAME=your_database_username
DATABASE_PASSWORD=your_database_password
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

## Running the server

```bash
rails server -p 5000
```

## API Endpoints

The API endpoints match the original Express.js backend:

### Users
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get a specific user by ID
- `POST /api/users` - Create a new user
- `PUT /api/users/:id` - Update an existing user
- `DELETE /api/users/:id` - Delete a user

### Expenses
- `GET /api/expenses` - Get all expenses with participants
- `GET /api/expenses/:id` - Get a specific expense by ID
- `POST /api/expenses` - Create a new expense
- `PUT /api/expenses/:id` - Update an existing expense
- `DELETE /api/expenses/:id` - Delete an expense

### Summary
- `GET /api/summary` - Get expense summary and calculated transactions
- `GET /api/summary/expense/:expense_id` - Get summary for a specific expense
- `GET /api/summary/expenses-with-status` - Get expenses with payment status counts
- `GET /api/summary/expenses-transactions` - Get all expenses with their transactions
- `POST /api/summary/payment/:payment_id` - Update payment status

## Migration Notes

This is a direct migration from the Express.js backend to Rails, maintaining all the same functionality and API endpoints. The key differences are:

1. Uses Ruby on Rails ActiveRecord instead of direct Supabase queries
2. Maintains the same models, relationships, and business logic
3. API endpoints have the same paths and response formats
4. API namespacing with the `/api` prefix

## Models

- **User**: Stores user information including name and bank details
- **Expense**: Records expenses with a name, amount, and payer
- **Participant**: Maps users to expenses with their share amount
- **PaymentStatus**: Tracks payment status between users for specific expenses

## Database Schema

The database schema includes:

- `users`: name, bank_account, bank_name
- `expenses`: name, amount, payer_id
- `participants`: user_id, expense_id, amount
- `payment_statuses`: expense_id, from_user_id, to_user_id, amount, status, paid_at
