class CompanyStatisticsSerializer < CompanySerializer
  attribute :id
  attribute :total_revenue
  attribute :total_no_of_booked_seats
  attribute :average_price_of_seats

  def total_revenue
    Booking.joins(:flight)
           .where('flights.company_id = ?', object.id)
           .sum('seat_price * bookings.no_of_seats')
  end

  def total_no_of_booked_seats
    Booking.joins(:flight)
           .where('flights.company_id = ?', object.id)
           .sum('bookings.no_of_seats')
  end

  def average_price_of_seats
    if total_no_of_booked_seats.positive?
      total_revenue / total_no_of_booked_seats
    else
      0
    end
  end
end
