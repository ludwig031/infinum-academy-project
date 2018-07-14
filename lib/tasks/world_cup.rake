# frozen_string_literal: true

namespace :world_cup do
  desc 'puts matches on given date in table'
  task :scores, [:date] => :environment do |_task, args|
    games = WorldCup.matches_on(args[:date])
    tp games, 'venue', 'home_team', 'away_team', 'score'
  end
end
