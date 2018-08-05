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

    def flight
      parameters = params[:booking][:flight_id]
      Flight.find(parameters) unless parameters.nil?
    end

    def days_left
      days = (flight.flys_at.to_date - Time.zone.now.to_date).to_i
      days > 15 ? 15 : days
    end

    def seat_price
      (flight.base_price + days_left * (flight.base_price / 15)).round
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
