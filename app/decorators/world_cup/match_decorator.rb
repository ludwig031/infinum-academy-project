module WorldCup
  class MatchDecorator < SimpleDelegator
    def home_team
      match_hash['home_team']['goals']
    end

    def away_team
      match_hash['away_team']['goals']
    end

    def score
      "#{home_team_goals} : #{away_team_goals}"
    end
  end
end
