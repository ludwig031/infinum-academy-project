RSpec.describe Flight, type: :model do
  subject(:flight) { FactoryBot.build(:flight) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_presence_of(:flys_at) }

  it { is_expected.to validate_presence_of(:lands_at) }

  it { is_expected.to validate_presence_of(:no_of_seats) }

  it { is_expected.to validate_presence_of(:base_price) }

  it 'flys_at before lands_at' do
    flight = FactoryBot.build(:flight,
                              flys_at: 8.days.from_now)
    flight.valid?
    expect(flight.errors[:lands_at])
      .to include('take off time can not be after landing time')
  end
end
