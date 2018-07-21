class BookingsController < ApplicationController
  def index
    params.permit
    render json: Booking.all, each_serializer: BookingSerializer
  end

  def show
    booking = Booking.find(params[:id])
    params.permit
    render json: booking, serializer: BookingSerializer
  end

  def new
    Booking.new
  end

  def create
    booking = Booking.new(booking_params)

    if booking.save
      render json: booking, status: :created
    else
      render json: booking.errors, status: :unprocessable_entity
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
    return unless booking.update(booking_params)
    redirect_to action: 'show', id: booking.id
  end

  def booking_params
    params.require(:booking).permit(:no_of_seats,
                                    :seat_price,
                                    :user_id,
                                    :flight_id)
  end
end
