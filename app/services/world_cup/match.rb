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
      Time.zone.parse(starts_at)
    end

    def home_team_goals
      match_hash['home_team']['goals']
    end

    def home_team_name
      match_hash['home_team']['country']
    end

    alias home_team home_team_name

    def home_team_code
      match_hash['home_team']['code']
    end

    def away_team_goals
      match_hash['away_team']['goals']
    end

    def away_team_name
      match_hash['away_team']['country']
    end

    alias away_team away_team_name

    def away_team_code
      match_hash['away_team']['code']
    end

    def events
      match_hash['home_team_events']
        .concat(match_hash['away_team_events'])
        .map do |event|
        WorldCup::Event.new(event)
      end
    end

    def goals
      events.select do |event|
        event.type == 'goal' ? Event.new(event) : next
      end
    end

    def goal_sum
      return '--' if status == 'future'
      home_team_goals + away_team_goals
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
        goals: goal_sum,
        score: score
      }
    end
  end
end
