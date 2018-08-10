module WorldCup
  class MatchDecorator < SimpleDelegator
    def home_team
      match_hash['home_team']['country']
    end

    def away_team
      match_hash['away_team']['country']
    end

    def score
      "#{home_team_goals} : #{away_team_goals}"
    end
  end
end
