class BookingSerializer < ActiveModel::Serializer
  attribute :id
  attribute :no_of_seats
  attribute :seat_price
  attribute :total_price
  attribute :flight_id
  attribute :user_id
  has_one :flight

  def total_price
    object.no_of_seats * object.seat_price
  end
end
