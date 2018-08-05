class BookingSerializer < ActiveModel::Serializer
  attribute :id
  attribute :no_of_seats
  attribute :seat_price
  attribute :total_price
  attribute :flight_name
  attribute :company_name
  attribute :flys_at

  has_one :flight

  def flight_name
    object.flight.name
  end

  def flys_at
    object.flight.flys_at
  end

  def company_name
    object.flight.company.name
  end

  def total_price
    object.no_of_seats * object.seat_price
  end
end
