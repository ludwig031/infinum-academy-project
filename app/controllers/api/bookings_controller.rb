module Api
  class BookingsController < ApplicationController
    before_action :authentication
    before_action :authorization, only: [:show, :update, :destroy]

    def index
      render json: Booking.where(user_id: @auth_user.id)
    end

    def show
      booking = Booking.find(params[:id])
      render json: booking
    end

    def create
      booking = Booking.new(booking_params)
      booking.user_id = @auth_user.id

      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      booking = Booking.find(params[:id])
      booking.destroy
    end

    def update
      booking = Booking.find(params[:id])

      if booking.update(booking_params)
        render json: booking
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    private

    def authorization
      booking = Booking.find(params[:id])
      if @auth_user.id == booking.user_id
      else
        render json: { errors: { resource: ['is forbidden'] } },
               status: :forbidden
      end
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats,
                                      :seat_price,
                                      :flight_id)
    end
  end
end
