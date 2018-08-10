RSpec.describe FlightCalculator do
  it 'calculates correct current price' do
    flight = build(:flight, flys_at: 10.days.from_now,
                            base_price: 100)
    expect(described_class.new(flight).price).to eq(133)
  end

  context 'when its more than 15 days till flight' do
    let(:flight) do
      build(:flight, flys_at: 16.days.from_now, base_price: 200)
    end

    it 'returns base price' do
      expect(described_class.new(flight).price).to eq(200)
    end
  end

  context 'when flight has passed' do
    let(:flight) do
      build(:flight, flys_at: 5.days.ago, base_price: 200)
    end

    it 'returns base price' do
      expect(described_class.new(flight).price).to eq(400)
    end
  end
end
