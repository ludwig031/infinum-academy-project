class FlightsController < ApplicationController
  def index
    params.permit
    render json: Flight.all, each_serializer: FlightSerializer
  end

  def show
    flight = Flight.find(params[:id])
    params.permit
    render json: flight, serializer: FlightSerializer
  end

  def new
    Flight.new
  end

  def create
    flight = Flight.new(flight_params)

    if flight.save
      render json: flight, status: :created
    else
      render json: flight.errors, status: :unprocessable_entity
    end
  end

  def destroy
    flight = Flight.find params[:id]
    flight.destroy
  end

  def edit
    Flight.find params[:id]
  end

  def update
    flight = Flight.find params[:id]
    return unless flight.update(flight_params)
    redirect_to action: 'show', id: flight.id
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
