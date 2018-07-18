RSpec.describe Flight, type: :model do
  let(:flight) { FactoryBot.create(:flight) }

  it 'is invalid without an name' do
    is_expected.to validate_presence_of(:name)
  end

  it 'is invalid without an taking off time' do
    is_expected.to validate_presence_of(:flys_at)
  end

  it 'is invalid without an landing time' do
    is_expected.to validate_presence_of(:lands_at)
  end

  it 'is invalid without seats' do
    is_expected.to validate_presence_of(:no_of_seats)
  end

  it 'is invalid without price' do
    is_expected.to validate_presence_of(:base_price)
  end

  it 'flys_at before lands_at' do
    Company.create(id: 1, name: 'Grunf').save
    flight = Flight.new(name: 'Idemo u Irsku',
                        no_of_seats: 50,
                        base_price: 100,
                        flys_at: Time.zone.now + 5.hours,
                        lands_at: Time.zone.now,
                        company_id: 1)
    flight.valid?
    expect(flight.errors[:lands_at]).to \
      include('take off time can not be after landing time')
  end
end
