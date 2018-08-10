RSpec.describe Booking, type: :model do
  subject(:booking) { FactoryBot.build(:booking) }

  it { is_expected.to validate_numericality_of(:seat_price) }

  it { is_expected.to validate_numericality_of(:no_of_seats) }

  it 'is invalid if flight is in past' do
    flight = FactoryBot.create(:flight,
                               flys_at: 5.hours.ago)
    booking = FactoryBot.build(:booking,
                               flight: flight)
    booking.valid?
    expect(booking.errors[:flight]).to include('must be booked in the future')
  end
end
