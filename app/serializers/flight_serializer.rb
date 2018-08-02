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
  has_many :bookings

  def company_name
    company&.name
  end

  def no_of_booked_seats
    bookings.sum(no_of_seats)
  end

  def days_left
    (object.flys_at - Date.now).to_i
  end

  def price
    (object.base_price + days_left * (object.base_price / 15)).round
  end

  def current_price
    if price < 2 * object.base_price
      price
    else
      2 * object.base_price
    end
  end
end
