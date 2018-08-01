module Api
  class BookingsController < ApplicationController
    before_action :authorization, only: [:show, :update, :destroy]

    def index
      render json: if params[:filter] == 'active'
                     current_user.bookings.active
                   else
                     current_user.bookings.ordered
                   end
    end

    def show
      render json: booking
    end

    def create
      booking = Booking.new(booking_params)
      booking.user_id = current_user.id

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

    def booking_params
      params.require(:booking).permit(:no_of_seats,
                                      :seat_price,
                                      :flight_id,
                                      :created_at)
    end
  end
end
