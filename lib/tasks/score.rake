namespace :world_cup do
  desc 'Display world cup scores'
  task :scores, [:date] => [:environment] do |_t, args|
    date = args[:date]
    date = Date.parse(date).strftime('%Y-%m-%d')
    games = WorldCup.matches_on(date)
    tp games, :venue, :home_team, :away_team, :score
  end
end
