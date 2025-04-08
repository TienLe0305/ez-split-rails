# frozen_string_literal: true

# HomeController handles requests to the home page of the application.
class HomeController < ApplicationController
  def index
    render json: { message: 'OK' }, status: :ok
  end
end
