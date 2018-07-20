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
    flight = Flight.new params[:flight]
    if flight.save
      redirect_to action: 'show', id: flight.id
    else
      render action: 'new'
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
    return unless flight.update(params[:flight])
    redirect_to action: 'show', id: flight.id
  end
end
