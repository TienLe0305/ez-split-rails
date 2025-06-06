module Api
  class UsersController < ApplicationController
    # GET /api/users
    def index
      @users = User.all
      render json: @users
    end
    
    # GET /api/users/:id
    def show
      @user = User.find(params[:id])
      render json: @user
    end
    
    # POST /api/users
    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    # PUT /api/users/:id
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        render json: @user
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    # DELETE /api/users/:id
    def destroy
      @user = User.find(params[:id])
      
      # Check if user has expenses or is a participant
      if @user.expenses.exists?
        render json: { error: 'Cannot delete user with associated expenses' }, status: :unprocessable_entity
        return
      end
      
      if @user.participants.exists?
        render json: { error: 'Cannot delete user that participates in expenses' }, status: :unprocessable_entity
        return
      end
      
      @user.destroy
      head :no_content
    end
    
    private
    
    def user_params
      params.require(:user).permit(:name, :bank_account, :bank_name)
    end
  end
end 