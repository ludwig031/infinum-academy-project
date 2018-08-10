class BookingForm < ActiveType::Record[Booking]
  before_save :set_seat_price, if: :no_of_seats_changed?

  def set_seat_price
    self.seat_price = FlightCalculator.new(flight).price
  end
end
