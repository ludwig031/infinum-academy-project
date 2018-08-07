class FlightSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :no_of_seats
  attribute :base_price
  attribute :current_price
  attribute :flys_at
  attribute :lands_at
  has_one :company
  attribute :company_id
  attribute :company_name
  attribute :no_of_booked_seats

  def company_name
    object.company.name
  end

  def no_of_booked_seats
    object.bookings.sum(:no_of_seats)
  end
end
