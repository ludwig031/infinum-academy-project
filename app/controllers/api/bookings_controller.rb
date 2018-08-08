module Api
  class BookingsController < ApplicationController
    rescue_from ActionController::BadRequest, with: :render_bad_request

    # before_action :authorization, only: [:show, :update, :destroy]

    def index
      render json: fetch_bookings
    end

    def show
      render json: booking
    end

    def create
      authorize Booking
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
      authorize Booking
      booking&.destroy
    end

    def update
      authorize Booking
      if booking.update(booking_params
                            .merge(seat_price: seat_price(booking.flight_id)))
        render json: booking
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    private

    def render_bad_request
      render json: { errors: { booking: ['is missing'] } },
             status: :bad_request
    end

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
