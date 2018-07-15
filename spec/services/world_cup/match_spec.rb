# frozen_string_literal: true

RSpec.describe WorldCup do
  attr_accessor :match

  before do
    @match = WorldCup::Match.new(
      'venue' => 'Moscow',
      'location' => 'Luzhniki Stadium',
      'status' => 'completed',
      'home_team_country' => 'France',
      'away_team_country' => 'Croatia',
      'datetime' => '2018-07-15T15:00:00Z',
      'home_team' => {
        'country' => 'France',
        'code' => 'FRA',
        'goals' => 4,
        'penalties' => 0
      },
      'away_team' => {
        'country' => 'Croatia',
        'code' => 'CRO',
        'goals' => 2,
        'penalties' => 0
      },
      'home_team_events' => [
        {
          'id' => 1186,
          'type_of_event' => 'goal',
          'player' => 'Paul POGBA',
          'time' => "59'"
        }
      ],
      'away_team_events' => [
        {
          'id' => 1180,
          'type_of_event' => 'goal',
          'player' => 'Ivan PERISIC',
          'time' => "28'"
        },
        {
          'id' => 1185,
          'type_of_event' => 'substitution-in',
          'player' => 'Marko PJACA',
          'time' => "86'"
        }
      ]
    )
  end

  describe 'Match#venue', :match_venue do
    it 'returns match venue' do
      expect(match.venue).to eq('Moscow')
    end
  end

  describe 'Match#status', :match_status do
    it 'returns match status' do
      expect(match.status).to eq('completed')
    end
  end

  describe 'Match#starts_at', :match_starts_at do
    it 'returns when does match start' do
      expect(match.starts_at).to eq('Sun, 15 Jul 2018 15:00:00 UTC +00:00')
    end
  end

  describe 'Match#home_team_goals', :match_home_team_goals do
    it 'returns home team goals at match' do
      expect(match.home_team_goals).to eq(4)
    end
  end

  describe 'Match#home_team_name', :match_home_team_name do
    it 'returns name of the home team' do
      expect(match.home_team_name).to eq('France')
    end
  end

  describe 'Match#away_team_goals', :match_away_team_goals do
    it 'returns away team goals at match' do
      expect(match.away_team_goals).to eq(2)
    end
  end

  describe 'Match#away_team_name', :match_away_team_name do
    it 'returns name of the away team' do
      expect(match.away_team_name).to eq('Croatia')
    end
  end

  describe 'Match#events', :match_events do
    it 'returns array of events' do
      expect(match.events).to be_a_kind_of Array
    end
    it 'has two elements' do
      expect(match.events.count).to eq(3)
    end
    it 'is an instance of WorldCup::Event' do
      expect(match.events).to all(be_an(WorldCup::Event))
    end
  end

  describe 'Match#goals', :match_goals do
    it 'returns array of events with type goal' do
      expect(match.goals).to be_a_kind_of Array
    end
    it 'has two elements' do
      expect(match.goals.count).to eq(2)
    end
  end
end
