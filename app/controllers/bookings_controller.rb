class BookingsController < ApplicationController
  def index
    render json: Booking.all, each_serializer: BookingSerializer
  end

  def show
    booking = Booking.find(params[:id])

    render json: booking, serializer: BookingSerializer
  end

  def new
    Booking.new
  end

  def create
    booking = Booking.new params[:booking]
    if booking.save
      redirect_to action: 'show', id: booking.id
    else
      render action: 'new'
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
    return unless booking.update(params[:booking])
    redirect_to action: 'show', id: booking.id
  end
end
