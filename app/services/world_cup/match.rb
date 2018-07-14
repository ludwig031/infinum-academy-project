# frozen_string_literal: true

module WorldCup
  # WorldCup::Match class creates single instance of world cup match
  class Match
    attr_accessor :match_hash

    def initialize(match_hash)
      @match_hash = match_hash
    end

    def venue
      match_hash['venue']
    end

    def status
      match_hash['status']
    end

    def starts_at
      starts_at = match_hash['datetime']
      Time.parse(starts_at).to_time
    end

    def home_team_goals
      match_hash['home_team']['goals']
    end

    def home_team
      match_hash['home_team']['country']
    end

    def home_team_code
      match_hash['home_team']['code']
    end

    def away_team_goals
      match_hash['away_team']['goals']
    end

    def away_team
      match_hash['away_team']['country']
    end

    def away_team_code
      match_hash['away_team']['code']
    end

    def events
      events = []
      match_hash['home_team_events'].each do |event|
        events << Event.new(event)
      end
      match_hash['away_team_events'].each do |event|
        events << Event.new(event)
      end
      events
    end

    def home_team_goals_array
      home_team_goals = []
      match_hash['home_team_events'].each do |event|
        event['type_of_event'] == 'goal' ? home_team_goals << event : next
      end
      home_team_goals
    end

    def away_team_goals_array
      away_team_goals = []
      match_hash['away_team_events'].each do |event|
        event['type_of_event'] == 'goal' ? away_team_goals << event : next
      end
      away_team_goals
    end

    def goals
      goals = []
      match_hash['home_team_events'].each do |event|
        event['type_of_event'] == 'goal' ? goals << event : next
      end
      match_hash['away_team_events'].each do |event|
        event['type_of_event'] == 'goal' ? goals << event : next
      end
      match_hash['status'] == 'completed' ? goals : '--'
    end

    def score
      # score = ''
      score = "#{home_team_goals} : #{away_team_goals}"
      status == 'completed' ? score : '--'
    end

    def as_json(_options = {})
      {
        venue: venue,
        status: status,
        home_team: home_team,
        away_team: away_team,
        goals: goals,
        score: score
      }
    end
  end
end
