module Api
  class FlightsController < ApplicationController
    def index
      render json: fetch_flights
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

    def fetch_flights
      if params[:company_id]
        Flight.by_company(params[:company_id].split(',')).active.ordered
      else
        Flight.active.ordered
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
