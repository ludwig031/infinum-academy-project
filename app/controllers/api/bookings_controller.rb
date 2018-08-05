module Api
  class BookingsController < ApplicationController
    before_action :authorization, only: [:show, :update, :destroy]

    def index
      render json: fetch_bookings
    end

    def show
      render json: booking
    end

    def create
      booking = Booking.new(booking_params)
      booking.user_id = current_user.id
      booking.seat_price = seat_price

      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      booking&.destroy
    end

    def update
      if booking.update(booking_params)
        booking.attributes[:seat_price] = seat_price
        render json: booking
      else
        render json: { errors: booking.errors }, status: :bad_request
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
