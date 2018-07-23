class BookingsController < ApplicationController
  def index
    render json: Booking.all
  end

  def show
    booking = Booking.find(params[:id])
    render json: booking
  end

  def new
    Booking.new
  end

  def create
    booking = Booking.new(booking_params)

    if booking.save
      render json: booking, status: :created
    else
      render json: { errors: booking.errors }, status: :bad_request
    end
  end

  def destroy
    booking = Booking.find params[:id]
    booking.destroy
  end

  def edit
    Booking.find params[:id]
  end

  def update
    booking = Booking.find params[:id]

    if booking.update(booking_params)
      render json: booking, status: :ok
    else
      render json: { errors: booking.errors }, status: :bad_request
    end
  end

  def booking_params
    params.require(:booking).permit(:no_of_seats,
                                    :seat_price,
                                    :user_id,
                                    :flight_id)
  end
end
