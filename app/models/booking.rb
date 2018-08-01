class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight

  validates :seat_price,
            presence: true,
            numericality: { greater_than: 0 }
  validates :no_of_seats,
            presence: true,
            numericality: { greater_than: 0 }
  validates :user, presence: true
  validates :flight, presence: true
  validate :future_booking

  def future_booking
    return if flight && flight.flys_at > Time.zone.now
    errors.add(:flys_at, 'must be booked in the future')
  end

  def self.ordered
    joins(:flight).order('flights.flys_at',
                         'flights.name',
                         'bookings.created_at')
  end

  def self.active
    joins(:flight).where('flights.flys_at > ?', Time.zone.now)
                  .order('flights.flys_at',
                         'flights.name',
                         'bookings.created_at')
  end
end
