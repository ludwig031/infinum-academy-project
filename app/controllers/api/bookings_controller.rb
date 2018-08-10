module Api
  class BookingsController < ApplicationController
    def index
      render json: fetch_bookings
    end

    def show
      authorize booking
      render json: booking
    end

    def create
      authorize Booking
      booking = BookingForm.new(booking_params)
      booking.user_id = current_user.id
      if booking.save
        render json: booking, serializer: BookingSerializer, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      authorize booking
      booking&.destroy
    end

    def update
      authorize booking
      form = ActiveType.cast(booking, BookingForm)
      if form.update(booking_params)
        render json: booking
      else
        render json: { errors: form.errors }, status: :bad_request
      end
    end

    private

    def booking
      @booking ||= Booking.find(params[:id])
    end

    def authorization
      return if current_user == booking.user
      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end

    def seat_price(flight_id = booking_params[:flight_id])
      return 0 if flight_id.nil?

      Flight.find(flight_id).current_price
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats,
                                      :flight_id)
    end

    def fetch_bookings
      if params[:filter] == 'active'
        current_user.bookings.active.ordered
      else
        current_user.bookings.ordered
      end
    end
  end
end
