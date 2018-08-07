class FlightStatisticsSerializer < ActiveModel::Serializer
  attribute :flight_id
  attribute :revenue
  attribute :no_of_booked_seats
  attribute :occupancy

  def occupancy
    if object.no_of_booked_seats.positive?
      ((object.no_of_booked_seats.to_f / object.no_of_seats) * 100).to_s << '%'
    else
      '0.0%'
    end
  end
end
