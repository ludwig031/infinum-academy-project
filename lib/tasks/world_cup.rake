namespace :world_cup do
  desc 'puts matches on given date in table'
  task :scores, [:date] => :environment do |_task, args|
    date = args[:date]
    date = Date.parse(date).strftime('%Y-%m-%d')
    games = WorldCup.matches_on(date)
    tp games, 'venue', 'home_team', 'away_team', 'score'
  end
end
