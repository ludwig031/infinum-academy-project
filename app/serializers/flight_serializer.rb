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
    (object.flys_at.to_date - Time.zone.now.to_date).to_i
  end

  def days_coefficient
    difference = 15 - days_left
    difference.positive? ? difference : 0
  end

  def current_price
    (days_coefficient / 15 * object.base_price + object.base_price).round
  end
end
