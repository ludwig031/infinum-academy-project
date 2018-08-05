class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight

  scope :ordered, lambda {
    joins(:flight).order('flights.flys_at',
                         'flights.name',
                         'bookings.created_at')
  }

  scope :active,
        -> { joins(:flight).where('flights.flys_at > ?', Time.zone.now) }

  validates :seat_price,
            presence: true,
            numericality: { greater_than: 0 }
  validates :no_of_seats,
            presence: true,
            numericality: { greater_than: 0 }
  validates :user, presence: true
  validates :flight, presence: true
  validate :not_in_future
  validate :not_overbooked

  def not_in_future
    return if flight && flight.flys_at > Time.zone.now
    errors.add(:flight, 'must be booked in the future')
  end

  def no_of_booked_seats
    Booking.select('SUM(no_of_seats) AS booked_seats')
           .find_by(flight_id: flight.id)
           .booked_seats.to_i
  end

  def not_overbooked
    return if flight.nil? || no_of_seats.nil? ||
              no_of_booked_seats + no_of_seats <= flight.no_of_seats
    errors.add(flight.no_of_seats, 'No more available seats')
  end
end
