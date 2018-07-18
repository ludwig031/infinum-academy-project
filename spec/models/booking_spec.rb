RSpec.describe Booking, type: :model do
  let(:booking) { FactoryBot.build :booking }

  it 'is invalid without number as seat price' do
    is_expected.to validate_numericality_of(:seat_price)
  end

  it 'is invalid without number as number of seats' do
    is_expected.to validate_numericality_of(:no_of_seats)
  end

  it 'is invalid if flight is in past' do
    booking.valid?
    expect(booking.errors[:flight_id]).to include('must be booked in the future')
  end
end
