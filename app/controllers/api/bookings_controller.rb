module Api
  class BookingsController < ApplicationController
    before_action :verify_authenticity_token
    before_action :authorized, only: [:show, :update, :destroy]

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

    # def set_booking
    #   if @auth_user
    #     booking = Booking.where(id: params[:id]).first
    #     if booking.user_id == @auth_user.id
    #       @booking = booking
    #     else
    #       render json: { errors: { resource: ['is forbidden'] } },
    #              status: :forbidden
    #     end
    #   else
    #     render json: { errors: { token: ['is invalid'] } }, status: 401
    #   end
    # end

    def authorized
      if @auth_user.id == params[:id]
      else
        render json: { errors: { resource: ['forbidden'] } },
               status: :forbidden
      end
    end

    def verify_authenticity_token
      token = request.headers['Authorization']
      @auth_user = User.find_by(token: token)
      if token && @auth_user

      else
        render json: { errors: { token: ['is invalid'] } }, status: 401
      end
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats,
                                      :seat_price,
                                      :flight_id)
    end
  end
end
