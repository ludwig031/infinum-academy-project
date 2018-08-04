class FlightStatisticsSerializer < FlightSerializer
  attribute :id
  attribute :revenue
  attribute :no_of_booked_seats
  attribute :occupancy

  def revenue
    Booking.joins(:flight)
           .where('flights.id = ?', object.id)
           .sum('seat_price * bookings.no_of_seats')
  end

  def no_of_booked_seats
    Booking.joins(:flight)
           .where('flights.id = ?', object.id)
           .sum('bookings.no_of_seats')
  end

  def occupancy
    if no_of_booked_seats.positive?
      (no_of_booked_seats.to_f / object.no_of_seats) * 100
    else
      0
    end
  end
end
