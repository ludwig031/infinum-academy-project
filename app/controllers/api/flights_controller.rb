module Api
  class FlightsController < ApplicationController
    before_action :verify_authenticity_token
    before_action :set_flight, only: [:index, :show, :update, :destroy]

    def index
      render json: Flight.all
    end

    def show
      flight = Flight.find(params[:id])
      render json: flight
    end

    def create
      flight = Flight.new(flight_params)

      if flight.save
        render json: flight, status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def destroy
      flight = Flight.find(params[:id])
      flight.destroy
    end

    def update
      flight = Flight.find(params[:id])

      if flight.update(flight_params)
        render json: flight
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    private

    def set_flight
      @flight = Flight.find(params[:id])
    end

    def verify_authenticity_token
      token = request.headers['Authorization']
      @auth_user = User.find_by(token: token)
      if token && @auth_user

      else
        render json: { errors: { token: ['is invalid'] } }, status: 401
      end
    end

    def flight_params
      params.require(:flight).permit(:name,
                                     :no_of_seats,
                                     :base_price,
                                     :flys_at,
                                     :lands_at,
                                     :company_id)
    end
  end
end
