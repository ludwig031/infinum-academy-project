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
  has_many :bookings
  attribute :days_left

  def company_name
    object.company.name
  end

  def no_of_booked_seats
    Booking.joins(:flight)
           .where('flights.company_id = ?', object.id)
           .sum('bookings.no_of_seats')
  end

  def days_left
    difference = (object.flys_at.to_date - Time.zone.now.to_date).to_i
    if difference.positive?
      difference
    else
      0
    end
  end

  def price
    (object.base_price + days_left * (object.base_price / 15)).round
  end

  def current_price
    if days_left.positive?
      price
    else
      2 * object.base_price
    end
  end
end
