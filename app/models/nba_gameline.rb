require 'date'
require 'rubygems'
require 'hpricot'
require 'open-uri'

class NbaGameline
  def self.update(schedule_date='')
    if(schedule_date == '')
      schedule_date = Date.current - 1
    end

    url = "http://www.nba.com/gameline/#{schedule_date.strftime('%Y%m%d')}"
    doc = open(url) {|f| Hpricot(f)}
    games = (doc/'.nbaMnStatsFtr')
    games.each do |game|
      href= game.search('a')[0]['href']
      away = href.split('/')[3][0..2]
      away_team = NbaTeam.find_by_abbreviation(away)
      home = href.split('/')[3][3..5]
      home_team = NbaTeam.find_by_abbreviation(home)

      puts "Schedule date: #{schedule_date}"
      puts "Home: #{home}\tAway: #{away}"

      local_game = NbaGame.where('home_team_id = ? AND gamedate = ?', home_team.id, schedule_date).first

      page = NbaGamePage.new("http://www.nba.com/#{href}")
      page.boxscore.home_stats.each do |stat|
        if(stat.minutes == 0 and stat.seconds == 0)
          next
        end

        player_url = stat.player_url
        if(!player_url.empty?)
          first, last = player_url.split('/')[2].split('_')
          puts "first name: #{first}, lastname: #{last}"
        end

        player = NbaPlayer.find_by_player_url(player_url.chomp('index.html'))
        if(player.nil?)
          player = find_missing_player(player_url, stat.player_name, home_team)
        end

        if(player.nil?)
          NbaStatImportError.create!(:href => href, :nba_team => home_team, 
                                     :player_name => stat.player_name, :nba_game => local_game)
          next
        end

        player.nba_game_player_stats.create(:nba_game_id => local_game.id, :minutes => stat.minutes,
                                           :seconds => stat.seconds, 
                                           :FGM => stat.FGM,
                                           :FGA => stat.FGA,
                                           :threePM => stat.threeGM,
                                           :threePA => stat.threeGA,
                                           :FTM => stat.FTM,
                                           :FTA => stat.FTA,
                                           :ORB => stat.ORB,
                                           :DRB => stat.DRB,
                                           :assists => stat.assists,
                                           :fouls => stat.fouls,
                                           :steals => stat.steals,
                                           :turnovers => stat.turnovers,
                                           :blocks => stat.blocked_shots,
                                           :points => stat.points)
      end

      page.boxscore.away_stats.each do |stat|
        if(stat.minutes == 0 and stat.seconds == 0)
          next
        end

        player_url = stat.player_url
        if(!player_url.empty?)
          first, last = player_url.split('/')[2].split('_')
          puts "first name: #{first}, lastname: #{last}"
        end

        player = NbaPlayer.find_by_player_url(player_url.chomp('index.html'))
        if(player.nil?)
          player = find_missing_player(player_url, stat.player_name, away_team)
        end

        if(player.nil?)
          NbaStatImportError.create!(:href => href, :nba_team => away_team, 
                                     :player_name => stat.player_name, :nba_game => local_game)
          next
        end

        player.nba_game_player_stats.create(:nba_game_id => local_game.id, :minutes => stat.minutes,
                                           :seconds => stat.seconds, 
                                           :FGM => stat.FGM,
                                           :FGA => stat.FGA,
                                           :threePM => stat.threeGM,
                                           :threePA => stat.threeGA,
                                           :FTM => stat.FTM,
                                           :FTA => stat.FTA,
                                           :ORB => stat.ORB,
                                           :DRB => stat.DRB,
                                           :assists => stat.assists,
                                           :fouls => stat.fouls,
                                           :steals => stat.steals,
                                           :turnovers => stat.turnovers,
                                           :blocks => stat.blocked_shots,
                                           :points => stat.points)
      end




    end
  end

  private 
    def self.find_missing_player(player_url, name, team)
      puts "Missing name: #{name}"
      puts "LastName: #{name.split(' ')[1]}"
      p = team.nba_players.find_by_lastname(name.split(' ')[1])
      if(!p.nil?)
        return p
      end

    end
end
