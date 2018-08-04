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
  validate :future_booking
  validate :not_overbooked

  def future_booking
    return if flight && flight.flys_at > Time.zone.now
    errors.add(:flys_at, 'must be booked in the future')
  end

  def not_overbooked
    return if flight_id.blank? || no_of_seats.blank?
    no_of_booked_seats = Booking.where(flight_id: :flight)
                                .sum(:no_of_seats)
    return if no_of_booked_seats + no_of_seats < flight.no_of_seats
    errors.add(:no_of_seats, 'no more available seats')
  end
end
