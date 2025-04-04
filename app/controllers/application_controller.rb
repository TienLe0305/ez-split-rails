class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  
  private
  
  def not_found
    render json: { error: 'Record not found' }, status: :not_found
  end
  
  def invalid_record(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
