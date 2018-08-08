class BookingForm < ActiveType::Record[Booking]
  include ActiveModel::Model

  attr_accessor :no_of_seats, :flight

  validates :no_of_seats, presence: true,
                          numericality: { greater_than: 0 }
  validates :flight, presence: true

  def save
    return false unless valid?

    Booking.create(no_of_seats: no_of_seats, flight_id: flight.id)
  end

  def first_name
    full_name.split(' ').first
  end

  def last_name
    full_name.split(' ').last
  end
end
