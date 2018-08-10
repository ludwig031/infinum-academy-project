namespace :world_cup do
  desc 'Display world cup scores'
  task :scores, [:date] => [:environment] do |_t, args|
    date = args[:date]
    date = Date.parse(date).strftime('%Y-%m-%d')
    match = WorldCup.matches_on(date)
    game = WorldCup::MatchDecorator.new(match)
    tp game, :venue, :home_team, :away_team, :score
  end
end
