RSpec.describe Booking, type: :model do
  subject(:booking) { FactoryBot.build(:booking) }

  it 'is invalid without number as seat price' do
    is_expected.to validate_numericality_of(:seat_price)
  end

  it 'is invalid without number as number of seats' do
    is_expected.to validate_numericality_of(:no_of_seats)
  end

  it 'is invalid if flight is in past' do
    flight = FactoryBot.build(:flight,
                              flys_at: Time.zone.now - 5.hours)
    booking = FactoryBot.build(:booking,
                               no_of_seats: 1,
                               seat_price: 2,
                               flight_id: flight)

    booking.valid?
    expect(booking.errors[:flight_id]).to \
      include('must be booked in the future')
  end
end
