desc "This task updates the daily stats from nba.com"
task :update_stats => :environment do
  puts "updating nba stats"
  gameline = NbaGameline.new
  gameline.update_stats

  puts "updating espn stats"
  espn_scoreboard = EspnScoreboardParser.new
  espn_scoreboard.update_stats

  puts "done" 
end
