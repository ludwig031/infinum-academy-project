class FlightStatisticsSerializer < ActiveModel::Serializer
  attribute :flight_id
  attribute :revenue
  attribute :no_of_booked_seats
  attribute :occupancy

  def occupancy
    if object.nil?
      '0.0%'
    else
      ((object.no_of_booked_seats.to_f / object.no_of_seats) * 100).to_s << '%'
    end
  end
end
