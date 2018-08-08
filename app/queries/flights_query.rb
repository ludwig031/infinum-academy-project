class FlightsQuery
  attr_reader :relation

  def initialize(relation: Flight.all)
    @relation = relation
  end

  def with_stats
    relation.left_outer_joins(:bookings)
            .group('flights.id')
            .select('flights.*, flights.id AS flight_id')
            .select('coalesce(sum(bookings.no_of_seats *
                          bookings.seat_price),0) AS revenue')
            .select('coalesce(sum(bookings.no_of_seats),0)
                          AS no_of_booked_seats')
  end
end
