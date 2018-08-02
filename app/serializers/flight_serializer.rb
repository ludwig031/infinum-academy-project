class FlightSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :no_of_seats
  attribute :base_price
  attribute :flys_at
  attribute :lands_at
  has_one :company
  attribute :company_id
  attribute :company_name
  has_many :bookings

  def company_name
    company&.name
  end

  def no_of_booked_seats
    bookings.sum(no_of_seats)
  end
end
