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

    def home_team_name
      match_hash['home_team']['country']
    end

    def home_team_code
      match_hash['home_team']['code']
    end

    def away_team_goals
      match_hash['away_team']['goals']
    end

    def away_team_name
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

    def goals
      goals = []
      match_hash['home_team_events'].each do |event|
        event['type_of_event'] == 'goal' ? goals << event : next
      end
      match_hash['away_team_events'].each do |event|
        event['type_of_event'] == 'goal' ? goals << event : next
      end
      status == 'completed' ? goals : '--'
    end

    def goals_sum
      sum = home_team_goals + away_team_goals
      status == 'completed' ? sum : '--'
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
        home_team_name: home_team_name,
        away_team_name: away_team_name,
        goals: goals_sum,
        score: score
      }
    end
  end
end
