desc "This task updates the daily stats from nba.com"
task :update_stats => :environment do
  puts "updating stats"
  NbaGameline.update
  puts "done" 
end
