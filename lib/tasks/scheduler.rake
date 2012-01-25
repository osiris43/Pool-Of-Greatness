desc "This task updates the daily stats from nba.com"
task :update_stats => :environment do
  puts "updating stats"
  gameline = NbaGameline.new
  gameline.update_stats
  puts "done" 
end
