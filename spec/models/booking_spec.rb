RSpec.describe Booking, type: :model do
  it 'is invalid without number as seat price' do
    is_expected.to validate_numericality_of(:seat_price)
  end

  it 'is invalid without number as number of seats' do
    is_expected.to validate_numericality_of(:no_of_seats)
  end
end
