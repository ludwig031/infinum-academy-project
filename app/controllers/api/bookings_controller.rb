module Api
  class BookingsController < ApplicationController
    before_action :verify_authenticity_token
    before_action :set_booking, only: [:show, :update, :destroy]

    def index
      render json: Booking.where(user_id: @auth_user.id)
    end

    def show
      render json: @booking
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
      @booking.destroy
    end

    def update
      if @booking.update(booking_params)
        render json: @booking
      else
        render json: { errors: @booking.errors }, status: :bad_request
      end
    end

    private

    def set_booking
      @booking = Booking.where(id: params[:id], user_id: @auth_user.id).first
      raise ActiveRecord::RecordNotFound if @booking.nil?
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
                                      :user_id,
                                      :flight_id)
    end
  end
end
