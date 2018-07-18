class BookingSerializer < ActiveModel::Serializer
  attribute :id
  attribute :no_of_seats
  attribute :seat_price
  belongs_to :user
  belongs_to :flight
  attribute :created_at
  attribute :updated_at
end
