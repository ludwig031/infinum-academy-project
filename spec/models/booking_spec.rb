RSpec.describe Booking, type: :model do
  subject(:booking) { FactoryBot.build(:booking) }

  it 'is invalid without number as seat price' do
    is_expected.to validate_numericality_of(:seat_price)
  end

  it 'is invalid without number as number of seats' do
    is_expected.to validate_numericality_of(:no_of_seats)
  end

  it 'is invalid if flight is in past' do
    booking = FactoryBot.build(:booking,
                               flight:
                                 FactoryBot.create(:flight,
                                                   flys_at:
                                                     Time.zone.now - 5.hours))
    booking.valid?
    expect(booking.errors[:flys_at]).to include('must be booked in the future')
  end
end
