class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight

  validates :seat_price,
            presence: true,
            numericality: { greater_than: 0 }
  validates :no_of_seats,
            presence: true,
            numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :flight_id, presence: true
  validate :future_booking

  def future_booking
    return if flight && flight.flys_at < Time.zone.now
    errors.add(:end_date, 'must be booked in the future')
  end
end
