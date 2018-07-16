RSpec.describe WorldCup do
let(:event) {
  WorldCup::Event.new(
    'id' => 402,
    'type_of_event' => 'goal',
    'player' => 'Luka MODRIC',
    'time' => "80'"
  )
}


describe 'Event#id', :event_id do
  it 'returns event id' do
    expect(event.id).to eq(402)
  end
end

describe 'Event#type', :event_type do
  it 'returns event type' do
    expect(event.type).to eq('goal')
  end
end

describe 'Event#player', :event_player do
  it 'returns event player' do
    expect(event.player).to eq('Luka MODRIC')
  end
end

describe 'Event#time', :event_time do
  it 'returns event id' do
    expect(event.time).to eq("80'")
  end
end

describe 'Event#to_s', :event_to_string do
  it 'returns modified event string' do
    expect(event.to_s).to eq("#402: goal@80' - Luka MODRIC")
  end
end
end
